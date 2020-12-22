{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_Katt (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/joel/.cabal/bin"
libdir     = "/home/joel/.cabal/lib/x86_64-linux-ghc-8.6.5/Katt-0.1.0.0-OLYQ7IGM4qHULObioFKdh-Katt"
dynlibdir  = "/home/joel/.cabal/lib/x86_64-linux-ghc-8.6.5"
datadir    = "/home/joel/.cabal/share/x86_64-linux-ghc-8.6.5/Katt-0.1.0.0"
libexecdir = "/home/joel/.cabal/libexec/x86_64-linux-ghc-8.6.5/Katt-0.1.0.0"
sysconfdir = "/home/joel/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Katt_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Katt_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Katt_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Katt_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Katt_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Katt_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
