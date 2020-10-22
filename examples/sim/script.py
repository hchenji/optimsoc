#!/usr/bin/env python

# Author: Marcelo Morales

import os
import pathlib
import shutil

def substitution(line, arg, dm):
    val = int(arg)  # parsing value of argument
    num = str(arg)
    argSqr = str(val * val)
    argSqr2 = str(val * val - 1)
    newLine = ""

    if "3x3 C9" in line:  # if statements to substitute a substring in a line
        newLine = line.replace("3x3 C9", num+"x"+num + " C" + argSqr)

    elif "tb_system_3x3_c9" in line:
        newLine = line.replace(
            "tb_system_3x3_c9", "tb_system_" + num + "x" + num + "_c" + argSqr)

    elif "system_3x3_c9_dm" in line:
        newLine = line.replace(
            "system_3x3_c9_dm", "system_" + num + "x" + num + "_c" + argSqr + "_dm")

    elif "3x3_c9_dm" in line:
        newLine = line.replace(
            "3x3_c9_dm",  num + "x" + num + "_c" + argSqr + "_dm")

    elif "system_3x3_c9_sim" in line:
        newLine = line.replace(
            "system_3x3_c9_sim", "system_" + num + "x" + num + "_c" + argSqr + "_sim")

    elif ":3" in line and dm:
        newLine = line.replace(":3", ":" + argSqr2)
        
    elif "(3)" in line:
        newLine = line.replace("(3)", "(" + num + ")")
        
    elif "8" in line:
        newLine = line.replace("8", str(val * val - 1))

    elif "9" in line:
        newLine = line.replace("9", argSqr)

    else:
        newLine = line
    return newLine  # return the new line

def generateDirectoryName(arg, dm):  # Argument of type string
    num = int(arg)  # converting string to number
    if dm == False : return "./system_" + str(num) + "x" + str(num) + "_c" + str(num*num)
    else : return "../../src/soc/hw/system_" + str(num) + "x" + str(num) + "_c" + str(num*num) + "_dm"

def generateFileName(arg, ext):  # Argument of type string
    num = int(arg)  # converting string to number
    # creating custom name
    if ext == ".sv" or ext == ".cpp": 
        return "/tb_system_" + str(num) + "x" + str(num) + "_c" + str(num*num) + ext
    
    elif ext == ".vh": return "/optimsoc_def.vh"
    
    else:  #core
        return "/system_" + str(num) + "x" + str(num) + "_c" + str(num*num) + "_sim" + ext

def generateFileNameDm(arg, ext):
    num = int(arg)
    
    if ext == ".sv" or ext == ".cpp":
        return generateDirectoryName(arg,True) + "/verilog/system_" + str(num) + "x" + str(num) + "_c" + str(num*num) + "_dm" + ext
    else: #core
        return  generateDirectoryName(arg,True)+"/system_" + str(num) + "x" + str(num) + "_c" + str(num*num) + "_dm" + ext


def generateVerilogDir(arg):
    dir = str(generateDirectoryName(arg,True) + "/verilog")
    
    if not os.path.exists(dir):
        os.makedirs(dir)
    
    # # if os.path.exists(dir):
    # #     shutil.rmtree(dir)
    # os.makedirs(dir)
        


def generateDmSv(arg, dirName, model):
    sqr = arg * arg
    
    fileName = generateFileNameDm(arg, ".sv")
    
    fin = open(model, "rt")
    
    #output file 
    fout = open( fileName, "wt")
    
    for line in fin:
        if "---INSERT DEBUG RING CODE" in line:
            for j in range(sqr - 1):
                output = "\tassign debug_ring_in["+str(j + 1) + "] = debug_ring_out["+str(j)+"];\n"
                fout.write(output)
            
            for j in range(sqr - 1):
                output = "\tdebug_ring_out_ready["+str(j) + "] = debug_ring_in_ready["+str(j + 1)+"];\n"
                fout.write(output)

        output = substitution(line, arg, True)
        fout.write(output)

def generateCpp(arg, dirName, model):
    
    num = str(arg)
    sqr = arg * arg
    sqrStr = str(sqr)
    
    fileName = generateFileName(arg, ".cpp")
    
    fin = open(model, "rt")

    # output file
    fout = open(dirName + fileName, "wt")

    # for each line in fin
    for line in fin:
        if "simctrl.addMemory" in line:
            break #this should leave us halfway inside the main
    
        output = substitution(line, arg, False)

        fout.write(output)

        
    for i in range(arg * arg):
        output = '\tsimctrl.addMemory("TOP.tb_system_' + num + 'x' + num + '_c'+ sqrStr + '.u_system.gen_ct[' + str(i) + '].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");\n'
        fout.write(output)
        
    output = "\tsimctrl.setMemoryFuncs(do_readmemh, do_readmemh_file);\n\tsimctrl.run();\n\n\treturn 0;\n}"
    fout.write(output)
    
    fin.close()  # close
    fout.close()  # close

def generateFile(arg, dirName, ext, model, dm):
    
    fileName = ""
    
    if dm == False:
        fileName = generateFileName(arg, ext)  # generate file name
    
    else: fileName = generateFileNameDm(arg, ext)
    
    # input file
    fin = open(model, "rt")

    # output file
    
    if dm == True:   fout = open( fileName, "wt")
    else: fout = open(dirName + fileName, "wt")

    # for each line in fin
    for line in fin:  
        output = substitution(line, arg, dm)

        fout.write(output)

    fin.close()  # close
    fout.close()  # close

def main():    
    print("Square topology: ")

    arg = input()
    
    # generating files for current directory
    dirName = generateDirectoryName(arg, False)
    dmDirName =  generateDirectoryName(arg, True)

    if not os.path.exists(dirName):
        os.makedirs(dirName)
    
    if not os.path.exists(dmDirName):
        os.mkdir(dmDirName)
    
    generateFile(arg, dirName, ".sv", "model/model.sv", False)  # creating Verilog File
    generateFile(arg, dirName, ".core", "model/model.core", False)  # creating .core File
    generateFile(arg, dirName, ".vh", "model/model.vh", False)
    generateCpp(arg, dirName, "model/model.cpp")

    #generating files for _dm directory
    
    generateVerilogDir(arg)
    
    generateDmSv(arg, dirName, "model/dm.sv")
    generateFile(arg, dirName,".core", "model/dm.core", True)

if __name__ == "__main__":
    main()
