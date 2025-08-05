# https://github.com/hstreamdb/hstreamdb-py/blob/main/examples/snippets/guides.py
import asyncio
import hstreamdb
import os

# NOTE: Replace with your own host and port
host = os.getenv("GUIDE_HOST", "127.0.0.1")
port = os.getenv("GUIDE_PORT", 6570)
stream_name = "your_stream" # MODIFICAR: Poner mi stream
subscription = "your_subscription"


# Run: asyncio.run(main(your_async_function))
async def main(*funcs):
    async with await hstreamdb.insecure_client(host=host, port=port) as client:
        for f in funcs:
            await f(client)


async def create_stream(client):
    await client.create_stream(
        stream_name, replication_factor=1, backlog=24 * 60 * 60, shard_count=1
    )

if __name__ == "__main__":
    asyncio.run(main(create_stream))
