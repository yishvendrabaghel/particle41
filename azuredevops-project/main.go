package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"
)

type Response struct {
	Timestamp string `json:"timestamp"`
	IP        string `json:"ip"`
}

func handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	timestamp := time.Now().Format(time.RFC3339)
	ip := r.Header.Get("X-Forwarded-For")
	if ip == "" {
		ip = r.RemoteAddr
	}

	response := Response{
		Timestamp: timestamp,
		IP:        ip,
	}

	jsonResponse, _ := json.MarshalIndent(response, "", "  ")
	w.Write(jsonResponse)
}

func main() {
	http.HandleFunc("/", handler)
	log.Println("SimpleTimeService runing on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}