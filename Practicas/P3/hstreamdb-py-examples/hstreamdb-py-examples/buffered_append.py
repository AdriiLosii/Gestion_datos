import asyncio
from hstreamdb import insecure_client, BufferedProducer


async def create_stream_if_not_exist(client, name):
    ss = await client.list_streams()
    if name not in {s.name for s in ss}:
        await client.create_stream(name, 1)


class AppendCallback(BufferedProducer.AppendCallback):
    def on_success(self, stream_name, payloads, stream_keyid: int):
        print(f"Append success with {len(payloads)} batches.")

    def on_fail(self, stream_name, payloads, stream_keyid, e):
        print("Append failed!")
        print(e)


async def buffered_appends(client, stream_name):
    p = client.new_producer(
        append_callback=AppendCallback(),
        size_trigger=10240,
        time_trigger=0.5,
        retry_count=2,
    )

    for i in range(50):
        await p.append(stream_name, "x")

    await asyncio.sleep(1)

    for i in range(50):
        await p.append(stream_name, "x")

    await p.wait_and_close()


async def buffered_appends_with_compress(client, stream_name):
    p = client.new_producer(
        append_callback=AppendCallback(),
        size_trigger=10240,
        time_trigger=0.5,
        retry_count=2,
        compresstype="gzip",
        compresslevel=9,
    )
    for i in range(50):
        await p.append(stream_name, "x")

    await asyncio.sleep(1)

    for i in range(50):
        await p.append(stream_name, "x")

    await p.wait_and_close()


async def main(host, port, stream_name):
    async with await insecure_client(host, port) as client:
        await create_stream_if_not_exist(client, stream_name)

        print("-> BufferedProducer")
        await buffered_appends(client, stream_name)

        print("-> BufferedProducer with compression")
        await buffered_appends_with_compress(client, stream_name)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="BufferedProducer Example")
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

    args = parser.parse_args()
    asyncio.run(main(args.host, args.port, args.stream_name))
