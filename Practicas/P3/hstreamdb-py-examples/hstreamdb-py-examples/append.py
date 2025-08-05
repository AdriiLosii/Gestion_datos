"""
Simple tool for writing to hstreamdb, demonstrating usage of the append API.
"""
import asyncio
import json
from hstreamdb import insecure_client


async def create_stream_if_not_exist(client, name):
    ss = await client.list_streams()
    if name not in {s.name for s in ss}:
        await client.create_stream(name)


async def appends_simple(client, stream_name):
    print("-> Append raw msg...")
    await client.append(stream_name, ["binmsg", "binmsg"])
    print("=> Done")

    print("-> Append hrecord msg...")
    await client.append(stream_name, [{"msg": "hello"}])
    print("=> Done")

    print("-> Append msg with gzip compression...")
    await client.append(stream_name, ["binmsg", "binmsg"], compresstype="gzip")
    print("=> Done")


async def appends_repl(client, stream_name, json_file):
    try:
        payload = json.loads(json_file)
        if isinstance(payload, list):
            await client.append(stream_name, payload, compresstype=None)
        else:
            await client.append(stream_name, [payload], compresstype=None)
    except json.decoder.JSONDecodeError:
        print("ERROR")


async def main(host, port, stream_name, simple=False, json_file="./JSON/actividades.json"):
    async with await insecure_client(host=host, port=port) as client:
        await create_stream_if_not_exist(client, stream_name)
        with open(json_file, 'r') as file:
            json_data = file.read()
            await appends_repl(client, stream_name, json_data)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Append Example")
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
        "--simple",
        help="run simple appends",
        default=False,
        action="store_true",
    )
    parser.add_argument(
        "--json_file",
        type=str,
        help="name of the json"
    )

    args = parser.parse_args()
    asyncio.run(
        main(args.host, args.port, args.stream_name, simple=args.simple, json_file=args.json_file)
    )
