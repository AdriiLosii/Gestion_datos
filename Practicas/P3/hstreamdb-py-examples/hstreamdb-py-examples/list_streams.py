import asyncio
from hstreamdb import insecure_client

async def main():
    async with await insecure_client(host="127.0.0.1", port=6570) as client:
        streams = await client.list_streams()
        print(list(streams))

if __name__ == "__main__":
    asyncio.run(main())