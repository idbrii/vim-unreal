
" Extract build errors from the last build from the game's logfile. Useful
" after using `module recompile ShooterGame`.
" logfile - Path to the log. Something like ShooterGame/Saved/Logs/ShooterGame.log
function! unreal#build#get_qf_from_log(logfile)
    let lazysave = &lazyredraw

    exec 'split '. a:logfile
    normal! G
    " Find most recent build output (there will be lots in this file).
    call search('Launching UnrealBuildTool', 'bWs')
    let pos = line('.')

    let tempfile = tempname()
    exec pos .',$ w '. tempfile
    exec 'edit '. tempfile
    setlocal noreadonly
    put =a:logfile
    " Sometimes, but not always, there's junk in front of the error. Not sure
    " when this doesn't occur. I saw it when using the Modules tab to
    " Recompile.
    %substitute /^.*CompilerResultsLog:Error: Error//e
    write
    exec 'cfile '. tempfile
    call delete(tempfile)
    close!

    let &lazyredraw = lazysave
endf


function! unreal#build#crashhandler_to_qf(crashhandler_text)
    Scratch
    0put =a:crashhandler_text
    " Move filename to beginning and setup line number how msvc likes it.
    " Convert from this format (Unreal crashhandler output):
    "   UE4Editor_Core!FRunnableThreadWin::Run() [d:\unreal\engine\source\runtime\core\private\windows\windowsrunnablethread.cpp:74]
    " to this format (for :compiler msvc):
    "   d:\unreal\engine\source\runtime\core\private\windows\windowsrunnablethread.cpp(74) : UE4Editor_Core!FRunnableThreadWin::Run()
    %sm/\v(.*) \[(.*):(\d+)\]/\2(\3) : \1
    cbuffer
    bdelete
endf


function! unreal#build#load_text_in_qf(compile_output)
    Scratch
    0put =a:compile_output

    " VS puts 23> in front of every line for some reason.
    %s/^\d\+>//

    " We output timings which mess with efm:
    " HierarchicalLODOutliner.generated.cpp (0:36.23 at +-204:-36:-18). Use sed
    " to remove them.
    %s/([[:digit:]]\+:[[:digit:]]\+\.[[:digit:]]\+ at.*)//

    cbuffer
    bdelete
endf

