/* Copyright (c) 2017 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 *
 * Constants
 *
 * Author(s):
 *   Stefan Wallentowitz <stefan@wallentowitz.de>
 */

package optimsoc_constants;
   // Maximum packet length
   localparam NOC_MAX_LEN = 32;

//#define OPTIMSOC_DEST_MSB 31
//#define OPTIMSOC_DEST_LSB 22
//#define OPTIMSOC_CLASS_MSB 21
//#define OPTIMSOC_CLASS_LSB 19
//#define OPTIMSOC_CLASS_NUM 8
//#define OPTIMSOC_SRC_MSB 18
//#define OPTIMSOC_SRC_LSB 9

   // NoC packet header
   // Mandatory fields
   localparam NOC_DEST_MSB = 31;
   localparam NOC_DEST_LSB = 22;
   localparam NOC_CLASS_MSB = 21;
   localparam NOC_CLASS_LSB = 19;
   localparam NOC_SRC_MSB = 18;
   localparam NOC_SRC_LSB = 9;

   // Classes
   localparam NOC_CLASS_LSU = 3'h2;

   // NoC LSU
   localparam NOC_LSU_MSGTYPE_MSB = 8;
   localparam NOC_LSU_MSGTYPE_LSB = 5;
   localparam NOC_LSU_MSGTYPE_READREQ = 3'h0;
   localparam NOC_LSU_SIZE_IDX = 15;
   localparam NOC_LSU_SIZE_SINGLE = 0;
   localparam NOC_LSU_SIZE_BURST = 1;

endpackage // constants
