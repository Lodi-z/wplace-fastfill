#Include <AudioTools>
class AudioSound {
	static soundMap := Map(
		"Fill_Begin", [A_ScriptDir "\sounds\曼波↗.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
		"Fill_End", [A_ScriptDir "\sounds\曼波↘.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
		"Pick", [A_ScriptDir "\sounds\哦耶.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
		"Draw", [A_ScriptDir "\sounds\wow~.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
	)

	static PlayAudioAsync(name) {
		if (!_SettingsData.playSnd)
			return
		AudioTools.PlayAudioAsync this.soundMap[name][_SettingsData.playSndType]
	}
}