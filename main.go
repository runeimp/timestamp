package main

import (
	"fmt"
	"os"
	"time"
)

const (
	appLabel          = "TimeStamp v1.0.0"
	layoutISO8601     = "2006-01-02_150405"
	layoutISO8601date = "2006-01-02"
)

func main() {
	dateTime := ""
	if len(os.Args) > 1 {
		dateTime = os.Args[1]
	}
	for i, arg := range os.Args {
		if i == 0 {
			continue
		}
		switch arg {
		case "-h", "-help", "--help":
			fmt.Printf(`%s
Usage: timestamp [OPTIONS] | [DATETIME]

OPTIONS:
  -h, -help, --help                display this help info
  -v, -ver, -version, --version    display the version of this app

DATETIME should be an ISO 8601 compatible time format such as
YYYY-MM-DD, YYYY-MM-DD_HH, YYYY-MM-DD_HHMM or YYYY-MM-DD_HHMMSS

`, appLabel)
			os.Exit(0)
		case "-v", "-ver", "-version", "--version":
			fmt.Println(appLabel)
			os.Exit(0)
		}
	}

	var (
		err error
		t   time.Time
	)

	// t, _ = time.Parse(time.RFC3339, "2006-01-02T15:04:05Z")

	if len(dateTime) == 0 {
		t = time.Now()
	} else {
		switch len(dateTime) {
		case 4:
			dateTime += "-01-01_000000"
		case 7:
			dateTime += "-01_000000"
		case 10:
			dateTime += "_000000"
		default:
			err = fmt.Errorf("not sure what to do with %q", dateTime)
			fmt.Fprintf(os.Stderr, "%v\n", err)
			os.Exit(1)
		}
		t, err = time.Parse(layoutISO8601, dateTime)
		if err != nil {
			fmt.Fprintf(os.Stderr, "time parsing error: %v\n", err)
			os.Exit(1)
		}
	}

	fmt.Println(t.Unix())
}
