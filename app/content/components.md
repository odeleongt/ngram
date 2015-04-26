### What makes up this app

Besides the code I developed for this capstone project,
`n-gram predictor` includes other free software.
The following is a list of these components
(full copies of the license agreements used by these components are included in their respective repositories):


- [`awesomplete`](https://leaverou.github.io/awesomplete/),
a lightweight autocomplete widget written in `js` by Lea Verou.
It actually uses the [Expat](https://directory.fsf.org/wiki/License:Expat) license,
which is usually (and ambiguously) referred to as the _MIT License_.

- [`ff`](http://cran.r-project.org/web/packages/ff/),
a package to use data stored on disk. Reduces memory use and speeds data access.
Only pointers to the disk-stored data are loaded on application startup,
and data is read as needed.
Daniel Adler, Christian Gläser, Oleg Nenadic, Jens Oehlschlägel and Walter Zucchini (2014).
ff: memory-efficient storage of large data on disk and fast access functions.
R package version 2.2-13. http://CRAN.R-project.org/package=ff


- [`data.table`](https://github.com/Rdatatable/data.table),
a package for efficient manipulation of data in-memory.
M Dowle, T Short, S Lianoglou, A Srinivasan with contributions from R Saporta and E Antonyan
(2014).
data.table: Extension of data.frame.
R package version 1.9.4.
http://CRAN.R-project.org/package=data.table


- [`stringi`](https://github.com/Rexamine/stringi/),
a package for efficient string manipulation in R based on libraries from the [ICU](http://site.icu-project.org/) project.
The "freeness" of its license is [vague](http://lists.gnucash.org/pipermail/gnucash-devel/2013-November/036318.html), but seems alright.
Gagolewski M., Tartanus B.
(2014).
R package stringi: Character string processing facilities.
http://stringi.rexamine.com/. DOI:10.5281/zenodo.12594



---



This application also uses other (non-open source) resources:


- The [`Big Huge Thesaurus`](https://words.bighugelabs.com/about.php) by John Watson.
The service provides an API to obtain words related to the query.
It tracks IP addresses, but the disclosure [seems fair](https://words.bighugelabs.com/privacy.php).
