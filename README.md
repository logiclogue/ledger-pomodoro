# Ledger Pomodoro

The goal of this project is to have a shell script that (a) runs for as long as the
specified pomodoro and (b) writes its stats in Ledger's time keeping format.

This would make the application both a productivity and time keeping tool.

My previous [pomodoro timer](https://github.com/logiclogue/pomodoro) was great,
but it didn't really give me a lot of information about where my time was going,
just that I had spent x number of seconds working.

## Usage

Basic default usage will run for 25 minutes and produce the following output:

```
$ ./pomodoro.sh
i 2019-02-01 21:00:00 Untitled
o 2019-02-01 21:25:00
```

The `-t` option specifies how long the pomodoro will run for:

```
$ ./pomodoro.sh -t 5
i 2019-02-01 21:25:00 Untitled
o 2019-02-01 21:30:00
```

The first argument is the name of the account that will be checked into:

```
$ ./pomodoro.sh Projects:LedgerPomodoro
i 2019-02-01 21:30:00 Projects:LedgerPomodoro
o 2019-02-01 21:55:00
```

A really nice feature is that you can switch tasks (or "accounts") any time
during your pomodoro. Let's say you were no longer working on your hobby project
and switched to checking your email:

```
$ ./pomodoro.sh Projects:LedgerPomodoro
  Tasks:Email

i 2019-02-01 22:00:00 Projects:LedgerPomodoro
o 2019-02-01 22:22:53

i 2019-02-01 22:22:53 Tasks:Email
o 2019-02-01 22:25:00
```

There is a feature that sends a notification `-n` number of seconds before the
end of the pomodoro. You specify the command to complete the countdown with.

**HERE**
