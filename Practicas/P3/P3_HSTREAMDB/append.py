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

async def appends_repl(client, stream_name, json_data):
    try:
        payload = json.loads(json_data)
        if isinstance(payload, list):
            await client.append(stream_name, payload, compresstype=None)
        else:
            await client.append(stream_name, [payload], compresstype=None)
    except json.decoder.JSONDecodeError as e:
        print("Error decoding JSON:", e)


async def main(host, port, stream_name,json_file):
    async with await insecure_client(host=host, port=port) as client:
        await create_stream_if_not_exist(client, stream_name)
        with open(json_file) as f:
            json_info=f.read()
            print('Añadiendo:',json_info)
            await appends_repl(client, stream_name,json_info)


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
        default="test_stream3",
    )
    parser.add_argument(
        "--json_file",
        type=str,
        help="run simple appends",
        default="/home/simon/Descargas/Gestion_Datos/Practicas/P3/hstreamdb-py-examples/hstreamdb-py-examples/ArchivosJSON/actividades.json",
    )

    args = parser.parse_args()
    asyncio.run(
        main(args.host, args.port, args.stream_name,json_file=args.json_file)
    )
