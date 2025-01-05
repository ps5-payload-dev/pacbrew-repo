/* Copyright (C) 2025 John Törnblom

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3, or (at your option) any
later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; see the file COPYING. If not, see
<http://www.gnu.org/licenses/>.  */

#include <stdio.h>

#include <llvm-c/Core.h>
#include <llvm-c/ExecutionEngine.h>


/**
 * Use LLVM to JIT the code:
 *   int func(int arg0, int arg1) {
 *     return arg0 + arg1;
 *   }
 *
 * then run:
 *    printf("%d + %d = %d\n", 10, 5, func_ptr(10, 5));
 **/
int main(void) {
  LLVMInitializeNativeTarget();
  LLVMInitializeNativeAsmPrinter();
  LLVMLinkInMCJIT();

  LLVMModuleRef mod = LLVMModuleCreateWithName("mod");

  LLVMTypeRef param_ty[] = {LLVMInt32Type(), LLVMInt32Type()};
  LLVMTypeRef func_ty = LLVMFunctionType(LLVMInt32Type(), param_ty, 2, 0);
  LLVMValueRef func = LLVMAddFunction(mod, "func", func_ty);

  LLVMBasicBlockRef entry = LLVMAppendBasicBlock(func, "entry");
  LLVMBuilderRef builder = LLVMCreateBuilder();
  LLVMPositionBuilderAtEnd(builder, entry);

  LLVMValueRef arg0 = LLVMGetParam(func, 0);
  LLVMValueRef arg1 = LLVMGetParam(func, 1);
  LLVMValueRef res = LLVMBuildAdd(builder, arg0, arg1, "res");
  LLVMBuildRet(builder, res);

  LLVMExecutionEngineRef engine;
  char *err = NULL;
  if(LLVMCreateJITCompilerForModule(&engine, mod, 2, &err) != 0) {
    puts(err);
    return -1;
  }

  int (*func_ptr)(int, int) = (void*)LLVMGetFunctionAddress(engine, "func");
  printf("%d + %d = %d\n", 10, 5, func_ptr(10, 5));

  return 0;
}
