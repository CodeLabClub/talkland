Class {
	#name : #HA,
	#superclass : #Object,
	#instVars : [
		'cli',
		'setting',
		'headers',
		'HA_host'
	],
	#classInstVars : [
		'cli',
		'headers'
	],
	#category : #Talkland
}

{ #category : #initialization }
HA >> initialize [
 	"加载配置"
	| access_token |
	setting := self loadSetting.
	HA_host := setting at: 'HA_host'.
	access_token := setting at: 'access_token'.
	cli := ZnClient new. "实例变量"
	headers :=  cli request headers.
	headers at: 'Content-Type' put: 'application/json'.
	headers at: 'Authorization' put: 'Bearer ', access_token.
	
	
	Transcript show:  ('Hello HA, load_setting: ', setting asString); cr. 

]

{ #category : #initialization }
HA >> loadSetting [
	"加载配置文件, 使用内置的json： https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md
	"

	| codelab_settings_dir  hass_setting  json_text|
	codelab_settings_dir := '/Users/wuwenjie/codelab_adapter'  asFileReference.
	hass_setting := (codelab_settings_dir/'hass.json') contents.
	"
yamlParser := PPYAMLGrammar new.
yaml_text :=  yamlParser parse: hass_setting asString.
yaml_text at: 'switch' at: '入口灯'.
# json
'/path/to/file.json' asFileReference
	readStreamDo: [ :readStream |
		STONJSON fromStream: readStream ]
	"
	json_text :=  STONJSON fromString: hass_setting asString. 
	"json_text at: 'switch' at: '入口灯'. "
	^ json_text.

]

{ #category : #control }
HA >> turnOff [
	"拟物, 就像房间里的开关
	turn off something
	"
 	|jsonObject|
	
	jsonObject := Dictionary new
		at: 'entity_id' put: ((setting at: 'devices') at: 'switch' at: '入口灯');
		yourself.
	cli
    		url: 
			HA_host,'/api/services/switch/turn_off';
			"'https://rpi.codelab.club:8123/api/services/light/turn_off';"
    		entity: (ZnEntity 
        		with: (STONJSON toString: jsonObject) "入口灯"
        		type: ZnMimeType applicationJson);
    		post.
		Transcript show:  ('turn off: ', '入口灯'); cr.
	
]

{ #category : #control }
HA >> turnOn [
	"拟物, 就像房间里的开关
	turn off something
	保持一定的冗余 是健康的
	"
 	|jsonObject|
	
	jsonObject := Dictionary new
		at: 'entity_id' put: ((setting at: 'devices') at: 'switch' at: '入口灯');
		yourself.
	cli
    		url: 
			HA_host,'/api/services/switch/turn_on';
			"'https://rpi.codelab.club:8123/api/services/light/turn_off';"
    		entity: (ZnEntity 
        		with: (STONJSON toString: jsonObject) "入口灯"
        		type: ZnMimeType applicationJson);
    		post.
		Transcript show:  ('turn on: ', '入口灯'); cr.
	
]
