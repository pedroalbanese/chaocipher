#!/usr/bin/env tclsh

proc rotate_left_alphabet {alphabet index} {
    set rotated [string range $alphabet $index end][string range $alphabet 0 [expr {$index - 1}]]
    set store [string index $rotated 1]
    set part1 [string range $rotated 2 13]
    set part2 [string range $rotated 14 end]
    return "[string index $rotated 0]$part1$store$part2"
}

proc rotate_right_alphabet {alphabet index} {
    set rotated [string range $alphabet $index end][string range $alphabet 0 [expr {$index - 1}]]
    set rotated [string range $rotated 1 end][string index $rotated 0]
    set store [string index $rotated 2]
    set part1 [string range $rotated 3 13]
    set part2 [string range $rotated 14 end]
    return "[string range $rotated 0 1]$part1$store$part2"
}

proc chaocipher {text mode} {
    set lAlphabet "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    set rAlphabet "PTLNBQDEOYSFAVZKGJRIHWXUMC"
    set output ""

    set text [string toupper $text]

    foreach c [split $text ""] {
        if {![string is alpha $c]} {
            append output $c
            continue
        }

        if {$mode eq "encrypt"} {
            set index [string first $c $rAlphabet]
            set mapped [string index $lAlphabet $index]
        } else {
            set index [string first $c $lAlphabet]
            set mapped [string index $rAlphabet $index]
        }

        append output $mapped

        set lAlphabet [rotate_left_alphabet $lAlphabet $index]
        set rAlphabet [rotate_right_alphabet $rAlphabet $index]
    }

    return $output
}

# Argumentos
set decrypt 0
if {[llength $argv] > 0 && [lindex $argv 0] eq "-d"} {
    set decrypt 1
}

# Leitura da entrada
set inputText ""
while {[gets stdin line] >= 0} {
    append inputText "$line"
}

# Execução
set inputText [string trim $inputText]
if {$decrypt} {
    puts [chaocipher $inputText "decrypt"]
} else {
    puts [chaocipher $inputText "encrypt"]
}
