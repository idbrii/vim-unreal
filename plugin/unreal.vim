if exists('loaded_unreal') || &cp || version < 700
    finish
endif
let loaded_unreal = 1

" Each project probably has a better version of this that knows the correct
" value of GAME_LOG_FILE.
"command! QfUnrealLoadErrorsFromLog call unreal#build#get_qf_from_log($GAME_LOG_FILE)

command! QfUnrealCrashhandlerPaste call unreal#build#crashhandler_to_qf(@+)
command! QfUnrealBuildLogPaste call unreal#build#load_text_in_qf(@+)
