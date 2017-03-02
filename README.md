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

With the LIWC 2007, external dictionaries were distributed with the software that could be used in the format read by Provalis Research's [*Wordstat*](http://provalisresearch.com/products/content-analysis-software/). Because I purchases a license for this product, I have that file and can use it with **LIWCalike**.

Using it is quite straightforward:

``` r
require(LIWCalike)
#> Loading required package: LIWCalike
require(quanteda)
#> Loading required package: quanteda
#> quanteda version 0.9.9.29
#> Using 7 of 8 cores for parallel computing
#> 
#> Attaching package: 'quanteda'
#> The following object is masked from 'package:utils':
#> 
#>     View
#> The following object is masked from 'package:base':
#> 
#>     sample

# read in the dictionary
liwc2007dict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2007.cat", 
                           format = "wordstat", encoding = "WINDOWS-1252")
tail(liwc2007dict, 1)
#> $`SPOKEN CATEGORIES.FILLERS`
#>  [1] "blah"         "idon’tknow"   "idontknow"    "imean"       
#>  [5] "ohwell"       "oranything*"  "orsomething*" "orwhatever*" 
#>  [9] "rr*"          "yakn*"        "ykn*"         "youknow*"

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
#>    docname Segment WC WPS Sixltr    Dic
#> 1    text1       1  8   3  37.50  62.50
#> 2    text2       2  6   5  16.67 166.67
#> 3    text3       3  4   2   0.00  50.00
#> 4    text4       4 16  12  12.50 187.50
#> 5    text5       5  4   1   0.00  75.00
#> 6    text6       6  7   3  14.29  57.14
#> 7    text7       7  7   3   0.00 142.86
#> 8    text8       8  5   4   0.00 300.00
#> 9    text9       9  9   2  11.11  33.33
#> 10  text10      10  9   2  22.22  44.44
#>    LINGUISTIC PROCESSES.FUNCTION WORDS Apostro
#> 1                                 25.0       0
#> 2                                 37.5       0
#> 3                                  0.0       0
#> 4                                 50.0       0
#> 5                                  0.0       0
#> 6                                 12.5       0
#> 7                                 25.0       0
#> 8                                 37.5       0
#> 9                                 12.5       0
#> 10                                25.0       0
```

How to Install
--------------

**LIWCalike** is currently only available on GitHub, not on CRAN. The best method of installing it is through the **devtools** package:

    devtools::install_github("kbenoit/LIWCalike")

This will also automatically install the **quanteda** package on which **LIWCalike** is built.

Comments and feedback
---------------------

I welcome your comments and feedback. Please file issues on the issues page, and/or send me comments at <kbenoit@lse.ac.uk>.
