#!/bin/bash
echo "****"
echo $1
echo "****"
source "$HOME/.sdkman/bin/sdkman-init.sh"
cd /workdir/
rm -rf asn1scc
git -C asn1scc pull || git clone /app/ asn1scc
cd asn1scc
git checkout $1
git pull
git rev-parse --abbrev-ref HEAD
dotnet build Antlr/ || exit 1
dotnet build parseStg2/ || exit 1
dotnet build "asn1scc.sln" || exit 1
cd v4Tests || exit 1
../regression/bin/Debug/net7.0/regression -l c -ws 4 -s false -p 48 || exit 1
../regression/bin/Debug/net7.0/regression -l Ada -ws 4 -s false -p 48 || exit 1
../regression/bin/Debug/net7.0/regression -l c -ws 8 -s true -p 48 -ig || exit 1
../regression/bin/Debug/net7.0/regression -l c -ws 8 -s true -p 48 || exit 1
../regression/bin/Debug/net7.0/regression -l Ada -ws 8 -s true -p 48 || exit 1

#scala tests
cd ../PUSCScalaTest || exit 1
dotnet test || exit 1
