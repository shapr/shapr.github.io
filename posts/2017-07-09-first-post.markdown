---
title: Faster Haskell code, by example!
description: how to speed up your Haskell code
---

# Introduction

Once you get past reading books and subject-specific blog posts, how do you bring all the pieces together and apply them to your own code?
This is the first in a series of blog posts of examining existing Haskell code with the goal of having bite sized conclusions I can use in my own code.

This series will start by solving programming puzzles for the [Advent of Code 2016](https://adventofcode.com/2016).
I will compare [my Haskell solutions](https://github.com/shapr/adventofcode2016) to those written by others, starting with [Day 1](http://adventofcode.com/2016/day/1).

If you'd like to follow along, write up your own solutions and see how they compare.

# First Comparison

## Strict Fields

I compared my solution to [glguy's solution](https://github.com/glguy/advent2016/blob/master/Day01.hs) and immediately noticed the use of strict fields, the exclamation points in front of the Int below:

```haskell
data Vec = Vec !Int !Int
```

That led me to the GHC User's Guide section on [producing a program that runs quicker](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/sooner.html#faster-producing-a-program-that-runs-quicker).

I also found a worthwhile [stack overflow post](https://stackoverflow.com/questions/8576795/advantages-of-strict-fields-in-data-types) on when strict fields are a good idea.

Further reading turned up the new GHC 8.0 pragma [Strict](http://blog.johantibell.com/2015/11/the-design-of-strict-haskell-pragma.html) and StrictData. Much of my Haskell code depends on laziness, so StrictData will probably be better for me.

## Use a Real Parser

Second I noticed that my code pattern matched on the input string I pasted directly into the file, while Eric's code read from an input file and used a 'real' parser.

I'd written parsers before in Haskell, but hadn't used the Applicative notation to do so. Applicative parsers are really easy to write:

```haskell
data Command = Command !Char !Int

parser :: Parser [Command]
parser = (Command <$> oneOf "LDRU" <*> number) `sepBy` string ", "
```

That motivated me to dig into [Haskell from First Principles](http://haskellbook.com) and do all the Applicative homework problems to prove to myself that I understood how to write parsers in that style.

## Addendum

If you've ever written C code, you've probably set a compiler flag to turn on all warnings. GHC has the same flag, but I didn't do that until several days into the contest. I strongly recommend turning on all warnings with `-Wall` and turning off any you don't want to see, I usually have `-fno-warn-missing-signatures`, probably because I write Python code for a living.
