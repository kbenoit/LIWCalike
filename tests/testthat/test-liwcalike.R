context('test liwcalike.R')

test_that("test dictionary count etc.", {
    
    txt <- c("The red-shirted lawyer gave her ex-boyfriend $300 out of pity:(.",
             "The green-shirted lawyer gave her $300 out of pity :(.")
    myDict <- dictionary(list(people = c("lawyer", "boyfriend"),
                              colorFixed = "red",
                              colorGlob = "red*",
                              mwe = "out of"))
    myCount <- liwcalike(txt, myDict, what = "word")
    
    toks <- tokens(txt[1], remove_hyphens = TRUE)
    num_words_txt1 <- ntoken(toks)
    
    # dictionary count
    num_people <- sum(toks$text1 == "lawyer") + sum(toks$text1 == "boyfriend")
    expect_equivalent(round(as.numeric(myCount$people[1]), 2), round(100*num_people/num_words_txt1, 2))

    # period count
    num_Period <- stringi::stri_count_fixed(txt[1], ".") / num_words_txt1 * 100
    expect_equivalent(round(as.numeric(myCount$Period[1]), 2), round(num_Period, 2))
    
    # Dic
    comp_toks <- tokens_compound(toks, myDict)
    num_dictionary_word <- num_people + length(grep("red", comp_toks)) + length(grep("out_of", comp_toks))
    expect_equivalent(round(as.numeric(myCount$Dic[1]), 2), round(100*num_dictionary_word/ntoken(comp_toks), 2))
})
