[![CRAN Version](http://www.r-pkg.org/badges/version/LIWCalike)](http://cran.r-project.org/package=LIWCalike) ![Downloads](http://cranlogs.r-pkg.org/badges/LIWCalike) [![Travis-CI Build Status](https://travis-ci.org/kbenoit/LIWCalike.svg?branch=master)](https://travis-ci.org/kbenoit/LIWCalike) [![Appveyor Build status](https://ci.appveyor.com/api/projects/status/kn31ca24tnnrbwth/branch/master?svg=true)](https://ci.appveyor.com/project/kbenoit/liwcalike/branch/master) [![codecov.io](https://codecov.io/github/kbenoit/LIWCalike/LIWCalike.svg?branch=master)](https://codecov.io/github/kbenoit/LIWCalike/coverage.svg?branch=master)

LIWCalike: an R implementation of the Linguistic Inquiry and Word Count
-----------------------------------------------------------------------

Built on the quanteda package for text analysis, LIWCalikes provides a simple interface to the analysis of text by counting words and other textual features, including the application of a dictionary to produce a tabular report of percentages. This provides similar functionality to the LIWC stand-alone software.

The user must supply a dictionary, which can include one of the custom LIWC dictionaries if these have been purchased from <http://liwc.wpengine.com>, or any other dictionary supplied by the user. The `dictionary()` constructor of the **quanteda** package, on which **LIWCalike** is built, can read both LIWC and Wordstat-formatted dictionary files, or you can use it to create a dictionary from an R list object (a named list of character vectors, where each character vector is a set of dictionary match patterns and its associated name is the dictionary key).

### Differences from the LIWC standalone software

This package is designed for R users and those wishing to build functionality by extending the [**quanteda**](https://github.com/kbenoit/quanteda) package for text analysis. If you prefer to have a complete, stand-alone user interface, then you should purchase and use the [LIWC standalone software](http://liwc.wpengine.com). This has several advantages:

-   LIWC allows direct importing of files, including binary (Word, pdf, etc) formats. To use **LIWCalike**, you will need to import these into the **quanteda** package first.
    **LIWCalike** also works fine with simple character vectors, if you prefer to use standard R methods to create your input object (e.g. `readLines()`, `read.csv()`, etc.)

-   LIWC provides direct outputs in the form of csv, Excel files, etc. By contrast, **LIWCalike** returns a `data.frame`, which you have to export yourself (e.g. using `write.csv()`.)

-   LIWC provides easy segmentation, through a GUI. By contrast, with **LIWCalike** you will have to segment the texts yourself. (**quanteda** provides easy ways to do this using `segment()` and `changeunits()`.)

-   LIWC color codes the dictionary value matches in your texts and displays these in a nice graphical window.

-   LIWC provides four composite measures that are not included in **LIWCalike**: "Analytic", "Clout", "Authentic", and "Tone". These are based on proprietary algorithms, as described and refernced in [Pennebaker, J.W., Boyd, R.L., Jordan, K., & Blackburn, K. (2015). The development and psychometric properties of LIWC2015. Austin, TX: University of Texas at Austin. D OI: 10.15781/T29G6Z](http://liwc.wpengine.com/wp-content/uploads/2015/11/LIWC2015_LanguageManual.pdf).

Using dictionaries with LIWCalike
---------------------------------

No dictionaries are supplied with **LIWCalike**, it is up to you to supply these. With the **quanteda** functions for creating or importing dictionaries, however, this is quite easy.

With the LIWC 2007, external dictionaries were distributed with the software that could be used in the format read by Provalis Research's [*Wordstat*](http://provalisresearch.com/products/content-analysis-software/). Because I purchases a license for this product, I have that file and can use it with **LIWCalike**. With LIWC 2015 dictionaries need to be extracted from the `LIWC2015-app-1.4.0.jar` file found in the installation folder of LIWC 2015 using `jar -xf LIWC2015-jfx.jar` (the dictionary can then be found in `./app/lib/com/liwc/LIWC2015/data/dict/LIWC2015_English.dic`). Note that in this case `format="LIWC"` needs to specified as parameter to the `dictionary` function.

Using it is quite straightforward:

``` r
library("LIWCalike")
library("quanteda")
#> quanteda version 0.99.9004
#> Using 7 of 8 threads for parallel computing
#> 
#> Attaching package: 'quanteda'
#> The following object is masked from 'package:utils':
#> 
#>     View

# read in the dictionary
liwc2007dict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2007.cat", 
                           format = "wordstat")
tail(liwc2007dict, 1)
#> Dictionary object with 1 primary key entry and 2 nested levels.
#> - [SPOKEN CATEGORIES]:
#>   - [ASSENT]:
#>     - absolutely, agree, ah, alright*, aok, aw, awesome, cool, duh, ha, hah, haha*, heh*, hm*, huh, lol, mm*, oh, ok, okay, okey*, rofl, uhhu*, uhuh, yah, yay, yea, yeah, yep*, yes, yup
#>   - [NON-FLUENCIES]:
#>     - er, hm*, sigh, uh, um, umm*, well, zz*
#>   - [FILLERS]:
#>     - blah, idon'tknow, idontknow, imean, ohwell, oranything*, orsomething*, orwhatever*, rr*, yakn*, ykn*, youknow*

# our test data
data_char_testphrases
#>  [1] "Test sentence for LIWCalike.  Second sentence."                   
#>  [2] "Each row is a document."                                          
#>  [3] "Comma, period."                                                   
#>  [4] "The red-shirted lawyer gave her ex-boyfriend $300 out of pity :(."
#>  [5] "LOL :)."                                                          
#>  [6] "(Parentheses) for $100."                                          
#>  [7] "Say \"what\" again!!"                                             
#>  [8] "Why are we here?"                                                 
#>  [9] "Other punctation: ^; %, &."                                       
#> [10] "Sentence one.  Sentence two! :-)"

# call LIWCalike
output <- liwcalike(data_char_testphrases, liwc2007dict)

# view some results
output[, c(1:7, ncol(output)-2)]
#>    docname Segment WC WPS Sixltr   Dic LINGUISTIC PROCESSES.FUNCTION WORDS
#> 1    text1       1  8   3  37.50 37.50                               25.00
#> 2    text2       2  6   5  16.67 50.00                               50.00
#> 3    text3       3  4   2   0.00 25.00                                0.00
#> 4    text4       4 18  12  11.11 61.11                               22.22
#> 5    text5       5  4   1   0.00 25.00                                0.00
#> 6    text6       6  7   3  14.29 28.57                               14.29
#> 7    text7       7  7   3   0.00 42.86                               28.57
#> 8    text8       8  5   4   0.00 80.00                               60.00
#> 9    text9       9  9   2  11.11 11.11                               11.11
#> 10  text10      10  9   2  22.22 22.22                               22.22
#>    Apostro
#> 1        0
#> 2        0
#> 3        0
#> 4        0
#> 5        0
#> 6        0
#> 7        0
#> 8        0
#> 9        0
#> 10       0
```

LIWCalike can also be used from python with the help of [rpy2](http://rpy2.readthedocs.io/).
```
# R dependencies of LIWCAlike
from rpy2.robjects.packages import importr
from rpy2.robjects import pandas2ri
liwcalike = importr("LIWCalike")
quanteda = importr("quanteda")

# Load Dictionary
liwc2015dict = quanteda.dictionary(file="/path/to/LIWC2015_English.dic", format = "LIWC")
txt = rpy2.robjects.vectors.StrVector(df.sentence)  # df.sentence is a pandas Series containing strings (i.e. dtype='O')
result = liwcalike.liwcalike(txt, liwc2015dict)
result_df = pandas2ri.ri2py(result)
```

How to Install
--------------

**LIWCalike** is currently only available on GitHub, not on CRAN. The best method of installing it is through the **devtools** package:

    devtools::install_github("kbenoit/LIWCalike")

This will also automatically install the **quanteda** package on which **LIWCalike** is built.

Comments, feedback, and code of conduct
---------------------------------------

I welcome your comments and feedback. Please file issues on the issues page, and/or send me comments at <kbenoit@lse.ac.uk>.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
