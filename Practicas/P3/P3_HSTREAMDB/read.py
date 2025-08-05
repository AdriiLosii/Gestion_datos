"""
Simple tool for reading from hstreamdb, demonstrating usage of the read API.
"""
import asyncio
from hstreamdb import insecure_client, ShardOffset, SpecialOffset


async def main(host, port, stream_name, reader_id, max_records):
    async with await insecure_client(host, port) as client:
        offset = ShardOffset()
        offset.specialOffset = SpecialOffset.EARLIEST
        async with client.with_reader(
            stream_name, reader_id, offset, 1000
        ) as reader:
            records = await reader.read(max_records)
            for i, r in enumerate(records):
                print(f"[{i}] payload: {r.payload}")


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
        default="test_stream2",
    )
    parser.add_argument(
        "--reader-id",
        type=str,
        help="id of the reader, default is 'test_reader'",
        default="test_reader",
    )
    parser.add_argument(
        "--max-records",
        type=int,
        help="max records to read each time, default is 10",
        default=10,
    )

    args = parser.parse_args()
    asyncio.run(
        main(
            args.host,
            args.port,
            args.stream_name,
            args.reader_id,
            args.max_records,
        )
    )
