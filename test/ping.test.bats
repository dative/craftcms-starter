#!/usr/bin/env bats

@test "can run our ping task" {
    run make ping
    [ "$status" -eq 0 ]
    [ "$output" = "pong" ]
}