/*
 * January 2004 - Changed to support H4 device
 * Copyright (c) 2004-2008 Texas Instruments
 *
 * (C) Copyright 2002
 * Gary Jennejohn, DENX Software Engineering, <garyj@denx.de>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)
SECTIONS
{
	. = BOOTADDR;

	. = ALIGN(4);

	.head   :
	{
		SOCDIR/spare_head.o	(.data)
	}
        .hash   :
        {
            SOCDIR/../uboot_hash.o      (.data)
        }
	. = ALIGN(1);

	.text	:
	{
		__int_vector_start = .;
		CPUDIR/start.o (.text*)
		__int_vector_end = .;
		*(EXCLUDE_FILE(STANDBYDIR/libstandby.o ).text)
	}

	. = ALIGN(16);
	.rodata :
	{
		*(EXCLUDE_FILE(STANDBYDIR/libstandby.o ).rodata*)
	}

	. = ALIGN(16);
	.data :
	{
		*(EXCLUDE_FILE(STANDBYDIR/libstandby.o ).data)
	}

	. = ALIGN(4);

	. = .;
	__u_boot_cmd_start = .;
	.u_boot_cmd : { *(.u_boot_cmd) }
	__u_boot_cmd_end = .;

	. = ALIGN(4);

	__image_copy_end = .;

	.rel.dyn : {
		__rel_dyn_start = .;
		*(.rel*)
		__rel_dyn_end = .;
	}

	.dynsym : {
		__dynsym_start = .;
		*(.dynsym)
	}

	_end = .;

	_standby_start_lma = .;
	.boot_standby STANDBY_ADDR :
	AT ( ADDR (.dynsym) + SIZEOF (.dynsym) )
	{
		_standby_start = .;
		STANDBYDIR/libstandby.o (.text .data .bss .rodata)
		_standby_end = .;
	}

	.bss __rel_dyn_start (OVERLAY) : {
		__bss_start = .;
		*(.bss)
		 . = ALIGN(4);
		__bss_end__ = .;
	}

	/DISCARD/ : { *(.dynstr*) }
	/DISCARD/ : { *(.dynamic*) }
	/DISCARD/ : { *(.plt*) }
	/DISCARD/ : { *(.interp*) }
	/DISCARD/ : { *(.gnu*) }
}
