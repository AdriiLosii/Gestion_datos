echo "CLIENTES APPEND"
echo ""
python append.py --json_file 'clientes.json' --stream-name test_stream3
echo "CLIENTES READ"
echo ""
python read.py --stream-name test_stream3
echo "ACTIVIDADES APPEND"
echo ""
python append.py --json_file 'actividades.json' --stream-name test_stream4
echo "ACTIVIDADES READ"
echo ""
python read.py --stream-name test_stream4
echo "ACTIVIDADES APPEND"
echo ""
python append.py --json_file 'viajes.json' --stream-name test_stream5
echo "ACTIVIDADES READ"
echo ""
python read.py --stream-name test_stream5
