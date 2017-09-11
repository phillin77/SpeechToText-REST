@echo off

if [%1]==[] goto usage
if [%2]==[] goto usage

setlocal enableextensions

set subscriptionKey=%~1
set filename=%~2
set output_format="simple"
set language="en-US"
set locale="en-US"
set recognition_mode="interactive"
 
FOR /F "tokens=*" %%I in ('curl -v -X POST "https://api.cognitive.microsoft.com/sts/v1.0/issueToken" ^
		-H "Content-type: application/x-www-form-urlencoded" -H "Content-Length: 0" ^
		-H "Ocp-Apim-Subscription-Key: %subscriptionKey%"') do (set token=%%I)


curl -v -X POST "https://speech.platform.bing.com/speech/recognition/%recognition_mode%/cognitiveservices/v1?language=%language%&locale=%locale%&format=%output_format%&requestid=rest_sample_request_id" ^
 -H "Transfer-Encoding: chunked" -H "Content-type: audio/wav; codec=\"audio/pcm\"; samplerate=44100" -H "Authorization: Bearer %token%" ^
 --data-binary @%filename%

endlocal
goto :eof

:usage
@echo Usage: %0 ^<subscription key^> ^<file to transcribe^>
exit /B 1