module Linear
( Matrix
, Vector
, RandomTransform

, dot
, mMult
, hadamard
, reshape
, randomList
, boxMuller
, normals
, uniforms
) where

import System.Random

-- BEGIN : TO BE FIXED BY ALEX
-- Just keep the same type signatures and make a note if you
-- change the names
type Vector a = [a]
type Matrix a = [[a]]

dot :: (Num a) => Vector a -> Vector a -> a
dot u v = sum $ zipWith (*) u v

vMult :: (Num a) => Matrix a -> Vector a -> Vector a
vMult m v = map (dot v) m

-- matrix multiplication m * n
mMult :: (Num a) => Matrix a -> Matrix a -> Matrix a
mMult [] n = []
mMult m n = vMult (transpose n) (head m) : mMult (drop 1 m) n

hadamard :: (Num a) => Matrix a -> Matrix a -> Matrix a
hadamard m n = zipWith (zipWith (*)) m n

-- Lovingly ripped from Data.List, type signature adjusted
transpose :: (Num a) => Matrix a -> Matrix a
transpose [] = []
transpose ([]: xss) = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])

scalar :: (Num a) => Matrix a -> a -> Matrix a
scalar mat n = map (map (* n)) mat

-- parameters
--   j is the number of columns of the resulting matrix
-- returns
--   i by j matrix where i is length of list / j
reshape :: (Num a) => Int -> [a] -> Matrix a
reshape j [] = []
reshape j list = [(take j list)] ++ reshape j (drop j list)

-- END : TO BE FIXED BY ALEX

-- Random Transformations

type RandomTransform a = [a] -> [a]

-- Initialize an infinite random list list with:
randomList :: (RandomGen g, Random a, Floating a) => RandomTransform a -> g -> [a]
randomList transform = transform . randoms

-- Define a transformation on the uniform distribution to generate
-- normally distributed numbers in Haskell (the Box-Muller transform)
boxMuller :: Floating a => a -> a -> (a, a)
boxMuller x1 x2 = (z1, z2) where z1 = sqrt ((-2) * log x1) * cos (2 * pi * x2)
                                 z2 = sqrt ((-2) * log x1) * sin (2 * pi * x2)

-- Apply the Box-Muller transform
normals :: Floating a => [a] -> [a]
normals (x1:x2:xs) = z1:z2:(normals xs) where (z1, z2) = boxMuller x1 x2
normals _ = []

uniforms :: Floating a => [a] -> [a]
uniforms xs = xs
