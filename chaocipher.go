package main

import (
	"flag"
	"strings"
	"fmt"
	"os"
	"io/ioutil"
	"unicode/utf8"
)

var (
	decrypt = flag.Bool("d", false, "Decrypt instead of Encrypt.")
)


func main() {
	flag.Parse()

	data, _ := ioutil.ReadAll(os.Stdin)
	b := strings.TrimSuffix(string(data), "\r\n")
	b = strings.TrimSuffix(b, "\n")
	b = strings.ToUpper(b)
	if *decrypt {
		plainText := Chao(string(b), Decrypt, true)
		fmt.Println(plainText)
	} else {
		cipherText := Chao(string(b), Encrypt, true)
		fmt.Println(cipherText)
	} 
}

type Mode int

const (
	Encrypt Mode = iota
	Decrypt
)

const (
	lAlphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
	rAlphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
)

func Chao(text string, mode Mode, showSteps bool) string {
	len := len(text)
	if utf8.RuneCountInString(text) != len {
		fmt.Println("Text contains non-ASCII characters")
		return ""
	}
	left := lAlphabet
	right := rAlphabet
	eText := make([]byte, len)
	temp := make([]byte, 26)

	for i := 0; i < len; i++ {
		if showSteps {
			fmt.Fprintln(os.Stderr, left, " ", right)
		}
		var index int
		if mode == Encrypt {
			index = strings.IndexByte(right, text[i])
			eText[i] = left[index]
		} else {
			index = strings.IndexByte(left, text[i])
			eText[i] = right[index]
		}
		if i == len-1 {
			break
		}

		for j := index; j < 26; j++ {
			temp[j-index] = left[j]
		}
		for j := 0; j < index; j++ {
			temp[26-index+j] = left[j]
		}
		store := temp[1]
		for j := 2; j < 14; j++ {
			temp[j-1] = temp[j]
		}
		temp[13] = store
		left = string(temp[:])

		for j := index; j < 26; j++ {
			temp[j-index] = right[j]
		}
		for j := 0; j < index; j++ {
			temp[26-index+j] = right[j]
		}
		store = temp[0]
		for j := 1; j < 26; j++ {
			temp[j-1] = temp[j]
		}
		temp[25] = store
		store = temp[2]
		for j := 3; j < 14; j++ {
			temp[j-1] = temp[j]
		}
		temp[13] = store
		right = string(temp[:])
	}
	return string(eText[:])
}
