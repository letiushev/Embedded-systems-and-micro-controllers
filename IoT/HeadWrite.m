% thingSpeakURL = 'http://api.thingspeak.com/';
% thingSpeakWriteURL = [thingSpeakURL 'update'];
% writeApiKey = 'YZ22ZCJH2CIVXO4I';
% fieldName = 'Var1';
% fieldValue = 'asdasda';
% response = webwrite(thingSpeakWriteURL,'api_key',writeApiKey,fieldName,fieldValue)

response = thingSpeakWrite(1721770,[2.3,1.2],'WriteKey','YZ22ZCJH2CIVXO4I')

tStamps = datetime('now')
response = thingSpeakWrite(1721770,'Fields',[1,2],'Values',{'test','data'},'WriteKey','YZ22ZCJH2CIVXO4I')