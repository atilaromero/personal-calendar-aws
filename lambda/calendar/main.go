package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/apognu/gocal"
	"github.com/aws/aws-lambda-go/lambda"
)

var calendarURL = os.Getenv("CALENDAR_URL")

// var timeout = 3 * time.Second

func init() {
	if calendarURL == "" {
		log.Println("CALENDAR_URL is empty")
	}
}

func LambdaHandler() ([]gocal.Event, error) {
	client := http.Client{
		// Timeout: timeout,
	}
	resp, err := client.Get(calendarURL)
	if err != nil {
		log.Printf("error retrieving calendar: %v", err)
		// not returning full error to avoid leaking the calendar URL
		return []gocal.Event{}, fmt.Errorf("error retrieving calendar")
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return []gocal.Event{}, fmt.Errorf("error fetching calendar not ok: %d", resp.StatusCode)
	}
	events, err := ParseCalendar(resp.Body)
	if err != nil {
		return []gocal.Event{}, fmt.Errorf("%w", err)
	}
	return events, nil
}

func ParseCalendar(r io.Reader) ([]gocal.Event, error) {
	c := gocal.NewParser(r)
	c.SkipBounds = true
	c.Parse()
	return c.Events, nil
}

func main() {
	lambda.Start(LambdaHandler)
}
