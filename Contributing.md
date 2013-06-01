CONTRIBUTING
------------
The initial pass on this list was always intended to be just that: initial. There's a lot of interesting data which could be parsed from the _./scripts/job_postings_ directory. I chose not to do so for two reasons:

1. Perfect was becoming the enemy of the good. If I kept following every "Ooh...wouldn't it be keen if!" whim then this list would never exist.
1. Programming is no longer my primary gig. I manage people and stuff. There are others out there with the skill to do more/better/faster with this data than I.

So **I am grateful for all pull requests and bug reports**. 

If you have the time, I'd appreciate that you follow these guidelines when submitting pull requests:

* If you manually modify one of the Perl_Company files, please make the corresponding change in the other Perl_Company file.
* Thanks to #22, we're having encoding issues. When you submit a pull request, please check the diff. If it includes every line which bears a diacritic then please just enter the information you need altered/added into an issue and I'll make the change manually for you.

**Please note!**

Even though this list was originally generated using information from [jobs.perl.org](http://jobs.perl.org), it is intended to reflect _all_ Perl-using companies. We merely used JPO because it was a good (and quick) source of a lot of information. If you know of a company which is not included here, please let us know! Either submit an issue or send a pull request and we'll get things added to the list.

**Future Plans**
Per Issue #18, we admit that what we have here is a database in a less than ideal form. TRUTH! There are better ways to present and update this information and we're hoping to evolve this list into something more user-friendly. Some of the things being considered:

* Storing the data in an RDBS
* Providing a UI for entering new information
* Providing a UI for updating existing information
* Including other information for each company
* Search functionality
* Data export functionality
* ...?

If you'd like to be a part of that (please be a part of that!), follow @perlcompanies on Twitter for updates.