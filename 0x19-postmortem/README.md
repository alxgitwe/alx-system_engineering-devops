Postmortem of Holberton School's System Engineering & DevOps Project 0x19
On the release of Holberton School's System Engineering & DevOps project 0x19 at approximately 00:07 Pacific Standard Time (PST), an outage occurred on an isolated Ubuntu 14.04 container running an Apache web server. When attempting to access the server, GET requests resulted in 500 Internal Server Errors instead of returning the expected HTML file for a simple Holberton WordPress site.
Debugging Process
The debugging journey began when our bug debugger, Brennan (affectionately dubbed BDB—yes, those are my actual initials), discovered the issue around 19:20 PST. Here’s how the troubleshooting unfolded:
Process Check: I started by examining active processes with ps aux, confirming that both apache2 processes (root and www-data) were running as expected.
Configuration Review: I navigated to the /etc/apache2/sites-available directory and verified that the web server was configured to serve content from /var/www/html/.
Trace Analysis: I utilized strace on the PID of the root Apache process while simultaneously sending a curl request to the server. Unfortunately, this yielded no useful insights.
Focused Tracing: I then repeated the tracing on the PID of the www-data process, keeping my expectations modest this time. This time, I was rewarded with valuable information—a -1 ENOENT (No such file or directory) error was logged when attempting to access /var/www/html/wp-includes/class-wp-locale.phpp.
File Inspection: I meticulously inspected files in the /var/www/html/ directory using Vim’s pattern matching feature to locate the erroneous .phpp extension. The culprit was found in wp-settings.php at line 137, where it incorrectly referenced require_once( ABSPATH . WPINC . '/class-wp-locale.phpp');.
Correction: I promptly removed the trailing 'p' from that line.
Final Test: A subsequent curl request confirmed success with a 200 OK response!
Automation: To prevent future occurrences of similar issues, I crafted a Puppet manifest to automate the correction of such errors.
Summary
In essence, this incident boiled down to a simple typo—gotta love those! Specifically, the WordPress application encountered a critical error in wp-settings.php while trying to load class-wp-locale.phpp. The correct filename, located in the wp-content directory, is actually class-wp-locale.php. The fix involved simply correcting this typo by removing an extra 'p'.
Prevention Strategies
This outage stemmed from an application error rather than a web server malfunction. To mitigate similar issues in the future, consider implementing these strategies:
Thorough Testing: Always test your application before deployment. This error could have been identified and resolved earlier if proper testing protocols were followed.
Status Monitoring: Utilize uptime monitoring services like UptimeRobot to receive immediate alerts if your website goes down.
Puppet Manifest: In response to this incident, I created a Puppet manifest named 0-strace_is_your_friend.pp. This script automates the correction of any identical errors by replacing .phpp extensions with .php in /var/www/html/wp-settings.php.
Of course, as programmers, we strive for perfection and aim to eliminate such errors entirely! 😉
