env=Release
output=./publish

rm -r $output 2>/dev/null

dotnet clean ./src
dotnet build ./src -c ${env}
dotnet publish ./src -c ${env} -o ${output}

cd publish

zip -r ../bundle.zip .
