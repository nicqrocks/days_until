##"Alexa, how many days until...?"

This repo is a small project that was made to get a feel for making services and 'skills' for the Amazon Echo and Alexa services. All it does (and will do) is tell the user how many days until a certain date arives. This means that if today is January 1st and you ask the Echo how many days until January 10th, it will reply with something along the lines of: "There are 10 days until January 10th."

The project is writen in Perl and is using CGI scripts on an Apache https server.

- `calc_days.pl` will handle figuring out how many days until a certain date.
- `front.cgi` will be the CGI scrip ttht will be run when a request is made.
- `events.csv` is a CSV file that holds aliases for certain dates that is used by `calc_days.pl`.
