xcodebuild build-for-testing -scheme sdkApiVideo -workspace sdkApiVideo.xcworkspace -destination 'platform=iOS Simulator,OS=13.0,name=iPhone 11'  -derivedDataPath 'build'
XCTESTRUN=`find ./build/Build/Products -name "*.xctestrun"`
cat $XCTESTRUN | tr '\n' '\r' | sed -e "s/\(<key>EnvironmentVariables<\/key>\r[^<]*<dict>\)/\1\r\t\t\t<key>API_KEY<\/key>\r\t\t\t<string>$1<\/string>/" | tr '\r' '\n'  > tmp.xctestrun
mv tmp.xctestrun $XCTESTRUN
xcodebuild test-without-building -xctestrun $XCTESTRUN -destination 'platform=iOS Simulator,OS=13.0,name=iPhone 11'