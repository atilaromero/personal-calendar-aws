package main

import (
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/apognu/gocal"
	"github.com/aws/aws-lambda-go/lambda"
)

type Input struct {
	CalendarURL string `json:"calendarURL"`
}

var errInputEmpty = `request must be on the form {calendarURL: "http://url.ics"}`

func LambdaHandler(i Input) ([]gocal.Event, error) {
	client := http.Client{
		// Timeout: timeout,
	}
	if i.CalendarURL == "" {
		return []gocal.Event{}, fmt.Errorf(errInputEmpty)
	}
	resp, err := client.Get(i.CalendarURL)
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
