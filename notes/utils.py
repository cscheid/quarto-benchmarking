import os
import timeit

def time_call(s, number=5):
    def call_it():
        result = os.system(s)
        if result != 0:
            raise Exception("call to '%s' failed with exit code %s" % (s, result))
    return timeit.timeit(lambda: os.system(s), number=number) / number

def with_dir(dir):
  ctx = {}  
  class WithDir(object):
    def __enter__(self):
      ctx["oldwd"] = os.getcwd()
      os.chdir(dir)
    def __exit__(self, *args):
      os.chdir(ctx["oldwd"])
  return WithDir()
