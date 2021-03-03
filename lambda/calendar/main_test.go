package main

import (
	"os"
	"testing"
)

func TestCalendarParser(t *testing.T) {
	f, err := os.Open("fixtures/basic.ics")
	if err != nil {
		t.Error(err)
	}

	events, err := ParseCalendar(f)
	if err != nil {
		t.Error(err)
	}
	if len(events) != 1 {
		t.Errorf("len(events) != 1: %d", len(events))
	}
}

func TestCalendarParserFull(t *testing.T) {
	f, err := os.Open("fixtures/2.ics")
	if err != nil {
		t.Error(err)
	}

	events, err := ParseCalendar(f)
	if err != nil {
		t.Error(err)
	}
	if len(events) != 2 {
		t.Errorf("len(events) != 2: %d", len(events))
	}
}

func TestEmptyRequest(t *testing.T) {
	i := Input{}
	_, err := LambdaHandler(i)
	if err == nil {
		t.Error("LambdaHandler should return an error.")
	}
	got := err.Error()
	expect := errInputEmpty
	if got != expect {
		t.Errorf("expect: '%v', got '%v'", expect, got)
	}
}
