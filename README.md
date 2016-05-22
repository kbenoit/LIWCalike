[![CRAN Version](http://www.r-pkg.org/badges/version/LIWCalike)](http://cran.r-project.org/package=LIWCalike) ![Downloads](http://cranlogs.r-pkg.org/badges/LIWCalike) [![Travis-CI Build Status](https://travis-ci.org/kbenoit/LIWCalike.svg?branch=master)](https://travis-ci.org/kbenoit/LIWCalike) [![codecov.io](https://codecov.io/github/kbenoit/LIWCalike/LIWCalike.svg?branch=master)](https://codecov.io/github/kbenoit/LIWCalike/coverage.svg?branch=master)

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
#> Loading required package: quanteda
#> quanteda version 0.9.6.9
#> 
#> Attaching package: 'quanteda'
#> The following object is masked from 'package:base':
#> 
#>     sample

# read in the dictionary
liwc2007dict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2007.cat", 
                           format = "wordstat")
#> Warning in strsplit(w, "\\("): input string 1 is invalid in this locale
tail(liwc2007dict, 1)
#> $`SPOKEN CATEGORIES.FILLERS`
#>  [1] "blah"         NA             "idontknow"    "imean"       
#>  [5] "ohwell"       "oranything*"  "orsomething*" "orwhatever*" 
#>  [9] "rr*"          "yakn*"        "ykn*"         "youknow*"

# our test data
testphrases
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
output <- liwcalike(testphrases, liwc2007dict)

# view some results
output[, c(1:7, ncol(output)-2)]
#>    docname Segment WC WPS Sixltr    Dic
#> 1    text1       1  6   3  50.00  83.33
#> 2    text2       2  5   5  20.00 200.00
#> 3    text3       3  2   2   0.00 100.00
#> 4    text4       4 12  12  16.67 250.00
#> 5    text5       5  1   1   0.00 300.00
#> 6    text6       6  3   3  33.33 133.33
#> 7    text7       7  3   3   0.00 333.33
#> 8    text8       8  4   4   0.00 375.00
#> 9    text9       9  2   2  50.00 150.00
#> 10  text10      10  4   2  50.00 100.00
#>    LINGUISTIC PROCESSES.FUNCTION WORDS Apostro
#> 1                                33.33       0
#> 2                                50.00       0
#> 3                                 0.00       0
#> 4                                66.67       0
#> 5                                 0.00       0
#> 6                                16.67       0
#> 7                                33.33       0
#> 8                                50.00       0
#> 9                                16.67       0
#> 10                               33.33       0
```

How to Install
--------------

**LIWCalike** is currently only available on GitHub, not on CRAN. The best method of installing it is through the **devtools** package:

    devtools::install_github("kbenoit/quanteda")
    devtools::install_github("kbenoit/LIWCalike")

The first install is present since you need to have installed the **quanteda** package of at least version 0.9.5-20 for this to work, since that update implemented multi-word dictionary values. As of 2016-04-16, this version was not on CRAN.

Comments and feedback
---------------------

I welcome your comments and feedback. Please file issues on the issues page, and/or send me comments at <kbenoit@lse.ac.uk>.
