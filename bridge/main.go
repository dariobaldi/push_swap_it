package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
)

type RequestBody struct {
	Args string `json:"args"`
}

func pushSwapHandler(w http.ResponseWriter, r *http.Request) {
	// Allow all origins — for testing
	w.Header().Set("Access-Control-Allow-Origin", "*")

	// Handle preflight (OPTIONS) request for CORS
	if r.Method == http.MethodOptions {
		w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		w.WriteHeader(http.StatusNoContent)
		return
	}

	var req RequestBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	// Get the directory of the current executable
	exePath, err := os.Executable()
	if err != nil {
		http.Error(w, "Failed to find executable path", http.StatusInternalServerError)
		return
	}
	dir := filepath.Dir(exePath)

	// Full path to push_swap
	pushSwapPath := filepath.Join(dir, "push_swap")

	// Prepare arguments
	args := []string{}
	if req.Args != "" {
		args = append(args, req.Args)
	}

	// Run the executable
	cmd := exec.Command(pushSwapPath, args...)
	stdout, err := cmd.Output()
	if err != nil {
		// If the command fails, we try to capture stderr
		if ee, ok := err.(*exec.ExitError); ok {
			http.Error(w, string(ee.Stderr), http.StatusInternalServerError)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "text/plain")
	w.Write(stdout)
}

func main() {
	http.HandleFunc("/push_swap", pushSwapHandler)

	port := "4221"
	log.Println("API running at http://localhost:" + port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal("Server failed: ", err)
	}
}
