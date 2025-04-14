<?php

function chao($text, $mode = 'encrypt', $showSteps = true)
{
    $text = strtoupper($text);
    if (preg_match('/[^A-Z]/', $text)) {
        fwrite(STDERR, "Text contains non-ASCII uppercase letters only\n");
        return '';
    }

    $left = str_split("HXUCZVAMDSLKPEFJRIGTWOBNYQ");
    $right = str_split("PTLNBQDEOYSFAVZKGJRIHWXUMC");
    $output = [];

    for ($i = 0; $i < strlen($text); $i++) {
        if ($showSteps) {
            fwrite(STDERR, implode('', $left) . "  " . implode('', $right) . PHP_EOL);
        }

        $ch = $text[$i];
        if ($mode === 'encrypt') {
            $index = array_search($ch, $right);
            $output[] = $left[$index];
        } else {
            $index = array_search($ch, $left);
            $output[] = $right[$index];
        }

        if ($i === strlen($text) - 1) {
            break;
        }

        // Permutação esquerda
        $left = rotateArray($left, $index);
        $store = $left[1];
        for ($j = 2; $j < 14; $j++) {
            $left[$j - 1] = $left[$j];
        }
        $left[13] = $store;

        // Permutação direita
        $right = rotateArray($right, $index);
        $store = $right[0];
        for ($j = 1; $j < 26; $j++) {
            $right[$j - 1] = $right[$j];
        }
        $right[25] = $store;
        $store = $right[2];
        for ($j = 3; $j < 14; $j++) {
            $right[$j - 1] = $right[$j];
        }
        $right[13] = $store;
    }

    return implode('', $output);
}

function rotateArray($arr, $index)
{
    $len = count($arr);
    return array_merge(array_slice($arr, $index), array_slice($arr, 0, $index));
}

// ===== CLI entry point =====

$options = getopt("d");
$decrypt = isset($options['d']);

$stdin = '';
while (!feof(STDIN)) {
    $stdin .= fread(STDIN, 1024);
}
$stdin = strtoupper(trim($stdin));

if ($decrypt) {
    echo chao($stdin, 'decrypt', true) . PHP_EOL;
} else {
    echo chao($stdin, 'encrypt', true) . PHP_EOL;
}
