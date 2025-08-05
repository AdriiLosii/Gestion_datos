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


async def appends_repl(client, stream_name):
    print(
        "You can input a string message or a json message.\n"
        "-----------------------------\n"
        "For example:\n"
        "input> raw_msg\n"
        "input> :gzip raw_msg\n"
        'input> {"msg": "hello, world"}\n'
        "-----------------------------"
    )
    while True:
        r = input("input> ")
        compresstype = None
        if r.startswith(":gzip "):
            r = r.split(maxsplit=1)[1]
            compresstype = "gzip"
        try:
            payload = json.loads(r)
        except json.decoder.JSONDecodeError:
            payload = r
        await client.append(stream_name, [payload], compresstype=compresstype)


async def main(host, port, stream_name, simple=False):
    async with await insecure_client(host=host, port=port) as client:
        await create_stream_if_not_exist(client, stream_name)
        if simple:
            await appends_simple(client, stream_name)
        else:
            await appends_repl(client, stream_name)


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

    args = parser.parse_args()
    asyncio.run(
        main(args.host, args.port, args.stream_name, simple=args.simple)
    )
