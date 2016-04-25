#' analyze text in a LIWC-alike fashion
#'
#' Analyze a set of texts to produce a dataset of percentages and other
#' quantities describing the text, similar to the functionality supplied by the
#' Linguistic Inquiry and Word Count standalone software distributed at
#' \url{http://liwc.wpengine.com}.
#' @param x input object, a \pkg{quanteda} \link[quanteda]{corpus} or character
#'   vector for analysis
#' @param dictionary a \pkg{quanteda} \link[quanteda]{dictionary} object
#'   supplied for analysis
#' @param toLower convert to common (lower) case before tokenizing
#' @param verbose if \code{TRUE} print status messages during processing
#' @param ... options passed to \code{\link[quanteda]{tokenize}} offering
#'   finer-grained control over how "words" are defined
#' @return a data.frame object containing the analytic results, one row per
#'   document supplied
#' @section Segmentation: The LIWC standalone software has many options for
#'   segmenting the text.  While this function does not supply segmentation
#'   options, you can easily achieve the same effect by converting the input
#'   object into a corpus (if it is not already a corpus) and using
#'   \link[quanteda]{changeunits} or \link[quanteda]{segment} to split the input
#'   texts into smaller units based on user-supplied tags, sentence, or
#'   paragraph boundaries.
#' @examples
#' liwcalike(testphrases)
#'
#' # examples for comparison
#' txt <- c("The red-shirted lawyer gave her ex-boyfriend $300 out of pity :(.")
#' myDict <- dictionary(list(people = c("lawyer", "boyfriend"),
#'                           colorFixed = "red",
#'                           colorGlob = "red*",
#'                           mwe = "out of"))
#' liwcalike(txt, myDict, what = "word")
#' liwcalike(txt, myDict, what = "fasterword")
#' (toks <- tokenize(txt, what = "fasterword", removeHyphens = TRUE))
#' length(toks[[1]])
#' # LIWC says 12 words
#'
#' \dontrun{# works with LIWC 2015 dictionary too
#' liwc2015dict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2015_English_Flat.dic",
#'                            format = "LIWC")
#' inaugLIWCanalysis <- liwcalike(inaugTexts, liwc2015dict)
#' }
#' @export
#' @import quanteda
liwcalike <- function(x, ...) {
    UseMethod("liwcalike")
}


#' @rdname liwcalike
#' @export
liwcalike.corpus <- function(x, ...) {
    liwcalike(texts(x), ...)
}

#' @rdname liwcalike
#' @export
liwcalike.character <- function(x, dictionary = NULL, toLower = TRUE, verbose = TRUE, ...) {

    ## initialize results data.frame
    ## similar to "Filename" and Segment
    result <-
        data.frame(docname = if (is.null(names(x))) paste0("text", 1:length(x)) else names(x),
                   Segment = 1:length(x), row.names = NULL, stringsAsFactors = FALSE)

    ## get readability before lowercasing
    WPS <- readability(x, "meanSentenceLength") #, ...)

    ## lower case the texts if required
    if (toLower) x <- toLower(x)

    ## if a dictionary is supplied, apply it to the dfm
    # first pre-process the text for multi-word dictionary values
    if (!is.null(dictionary)) {
        x <- phrasetotoken(x, dictionary, case_insensitive = toLower)
        if (dictionary@concatenator != "_")
            dictionary <- lapply(dictionary, stringi::stri_replace_all_fixed, dictionary@concatenator, "_")
    }

    ## tokenize and form the dfm
    toks <- tokenize(x, removePunct = TRUE, removeHyphens = TRUE, ...)
    dfmAll <- dfm(toks, verbose = FALSE)
    if (!is.null(dictionary))
        dfmDict <- dfm(toks, verbose = FALSE, dictionary = dictionary)
        # or applyDictionary() to dfm

    ## WC
    result[["WC"]] <- ntoken(toks)
    # maybe this should be ntoken(dfmAll) - does LIWC count punctuation??

    ## no implementation for: Analytic	Clout	Authentic	Tone

    ## WPS (mean words per sentence)
    result[["WPS"]] <- WPS

    ## Sixltr
    result[["Sixltr"]] <- sapply(toks, function(y) sum(stringi::stri_length(y) > 6)) / result[["WC"]] * 100

    ## Dic (percentage of words in the dictionary)
    result[["Dic"]] <- if (!is.null(dictionary)) ntoken(dfmDict) / ntoken(dfmAll) * 100 else NA

    ## add the dictionary counts, transformed to percentages of total words
    if (!is.null(dictionary))
        result <- cbind(result,
                        as.data.frame(dfmDict / rep(result[["WC"]], each = nfeature(dfmDict)),
                                      row.names = FALSE) * 100)

    ## punctuation counts
    # AllPunc
    result[["AllPunc"]] <- stringi::stri_count_charclass(x, "\\p{P}") / result[["WC"]] * 100

    # Period
    result[["Period"]] <- stringi::stri_count_fixed(x, ".") / result[["WC"]] * 100

    # Comma
    result[["Comma"]] <- stringi::stri_count_fixed(x, ",") / result[["WC"]] * 100

    # Colon
    result[["Colon"]] <- stringi::stri_count_fixed(x, ":") / result[["WC"]] * 100

    # SemiC
    result[["SemiC"]] <- stringi::stri_count_fixed(x, ";") / result[["WC"]] * 100

    # QMark
    result[["QMark"]] <- stringi::stri_count_fixed(x, "?") / result[["WC"]] * 100

    # Exclam
    result[["Exclam"]] <- stringi::stri_count_fixed(x, "!") / result[["WC"]] * 100

    # Dash
    result[["Dash"]] <- stringi::stri_count_charclass(x, "\\p{Pd}") / result[["WC"]] * 100

    # Quote
    result[["Quote"]] <- stringi::stri_count_charclass(x, "[:QUOTATION_MARK:]")/ result[["WC"]] * 100

    # Apostro
    result[["Apostro"]] <- stringi::stri_count_charclass(x, "['\\u2019]") / result[["WC"]] * 100

    # Parenth -- note this is specified as "pairs of parentheses"
    result[["Parenth"]] <- min(c(stringi::stri_count_fixed(x, "("),
                                  stringi::stri_count_fixed(x, ")"))) / result[["WC"]] * 100

    # OtherP
    result[["OtherP"]] <- stringi::stri_count_charclass(x, "\\p{Po}") / result[["WC"]] * 100

    # format the result
    result[, which(names(result)=="Sixltr") : ncol(result)] <-
        format(result[, which(names(result)=="Sixltr") : ncol(result)],
               digits = 4, trim = TRUE)

    result
}


