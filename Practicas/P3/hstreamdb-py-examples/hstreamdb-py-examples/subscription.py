"""
Simple tool for reading from hstreamdb, demonstrating usage of the subscription API.
"""
import asyncio
from hstreamdb import insecure_client


async def create_subscription_if_not_exist(client, subscription, stream_name):
    ss = await client.list_subscriptions()
    if subscription not in {s.subscription_id for s in ss}:
        await client.create_subscription(
            subscription, stream_name, ack_timeout=600, max_unacks=10000
        )


class Processing:
    count = 0
    max_count: int

    def __init__(self, max_count):
        self.max_count = max_count

    async def __call__(self, ack_fun, stop_fun, rs_iter):
        rs = list(rs_iter)
        for r in rs:
            self.count += 1
            print(f"[{self.count}] Receive: {r}")
            if self.max_count > 0 and self.count >= self.max_count:
                await stop_fun()
                break

        await ack_fun(r.id for r in rs)


async def main(host, port, subid, stream_name, count):
    async with await insecure_client(host, port) as client:
        await create_subscription_if_not_exist(client, subid, stream_name)
        consumer = client.new_consumer(
            "test_consumer", subid, Processing(count)
        )
        await consumer.start()


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Consumer Example")
    parser.add_argument(
        "--host", type=str, help="server host", default="127.0.0.1"
    )
    parser.add_argument("--port", type=int, help="server port", default=6570)
    parser.add_argument(
        "--stream-name",
        type=str,
        help="name of the stream, default is 'test_stream'",
        default="test_stream",
    )
    parser.add_argument(
        "--subscription",
        type=str,
        help="id of the subscription, default is 'test_subscription'",
        default="test_subscription",
    )
    parser.add_argument(
        "--count",
        type=int,
        help="total messages to read, negative means infinite, default is -1",
        default=-1,
    )

    args = parser.parse_args()
    asyncio.run(
        main(
            args.host,
            args.port,
            args.subscription,
            args.stream_name,
            args.count,
        )
    )
