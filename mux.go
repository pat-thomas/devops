package main

import (
  "fmt"
  //"os"
  //"github.com/codegangsta/cli"
)

func outputCurrentTmuxSessions() { 
  fmt.Println("some tmux session")
  fmt.Println("another tmux session")
}

func readFirstCommandLineArg() string { 
  fmt.Println("reading the first command line argument")
  return "list"
}

func killTmuxSession(sessionName string) { }
func sessionsExist() bool { return true }
func createStandardTmuxSession(sessionName string) { }
func pullOffWorkingDirectory() string { return "foo" }
func createNewSession(sessionName string) { }

func main() {
  firstCommandLineArg := readFirstCommandLineArg()
  if (firstCommandLineArg == "list") {
    outputCurrentTmuxSessions()
  } else if (firstCommandLineArg == "kill") {
    killTmuxSession(firstCommandLineArg)
  } else if (firstCommandLineArg == "--here") {
    newSession := pullOffWorkingDirectory()
    fmt.Printf("defining new session %s\n", newSession)
  }
}
