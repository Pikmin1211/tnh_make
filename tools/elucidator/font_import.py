'''
font_import.py

Script to create an event file to install font image files.

Author:
	Kirito
'''

import argparse
import textwrap
import os
from PIL import Image
from pathlib import Path

parser = argparse.ArgumentParser(
	description = 'Script to create an event file to install font image files.'
)
parser.add_argument(
	'--input',
	type = str,
	nargs = '+',
	help = 'Filenames of font image binaries.',
	required = True
)
parser.add_argument(
	'--input-image',
	type = str,
	nargs = '+',
	help = 'Filenames of font image files.',
	required = True
)
parser.add_argument(
	'--output',
	type = str,
	help = 'Filename of output file.',
	required = True
)
parser.add_argument(
	'--relative-path',
	type = str,
	help = 'Relative file path of the inputs and output files.',
	required = True
)
parser.add_argument(
	'--name',
	type = str,
	help = 'Name of installer.',
	required = False
)
parser.add_argument(
	'--width',
	type = int,
	help = 'Extra width to add to characters',
	required = False
)

special_ascii_table = [
	['apostrophe', '\''],
	['asterisk', '*'],
	['bang', '!'],
	['bracket_left', '['],
	['bracket_right', ']'],
	['colon', ':'],
	['comma', ','],
	['compare_equal', '='],
	['compare_greater', '>'],
	['compare_less', '<'],
	['dash', '-'],
	['parenthesis_left', '('],
	['parenthesis_right', ')'],
	['percent', '%'],
	['period', '.'],
	['plus', '+'],
	['question', '?'],
	['quote', '\"'],
	['semicolon', ';'],
	['slash_forward', '/'],
	['space', ' '],
	['tilde', '~']
]

def get_char_width(file: str):
	image = Image.open(file)
	w, h = image.size
	furthest = 0
	for x in range(w):
		for y in range(h):
			if image.getpixel((x, y)) != 0:
				furthest = x
	if furthest == 0:
		furthest = 3 #space
	return furthest

def get_special_ascii(name: str):
	for entry in special_ascii_table:
		if name == entry[0]:
			return ord(entry[1])
	print(f'Special character \"{name}\" not defined.')
	return None

def get_ascii_byte(file: str):
	file = get_file_name(file)
	if len(file) == 1:
		return(ord(file))
	return get_special_ascii(file)

def get_file_name(file: str):
	return Path(file).with_suffix('').name

args = parser.parse_args()

if (args.width is None):
	args.width = 0

os.makedirs(os.path.dirname(args.output), exist_ok=True)
with open(args.output, 'w') as outfile:

	outfile.write(textwrap.dedent(f'''\
		// File output by font_import
		// Do not edit!

		#ifndef FONT_INSTALLER
			#define FONT_INSTALLER
			#define FontEntry(NextFont,ASCII,Width) "POIN NextFont; BYTE ASCII Width 0 0"
			#define FontEntry(ASCII,Width) "BYTE 0 0 0 0 ASCII Width 0 0"
			#endif //FONT_INSTALLER
	'''))

	i = 0
	while i < len(args.input):
		file = args.input[i]
		image_file = args.input_image[i]
		file = os.path.relpath(file, args.relative_path)
		if i+1 == len(args.input):
			outfile.write(textwrap.dedent(f'''\
				
				ALIGN 4
				{args.name}FontEntryNumber{i}:
				FontEntry({get_ascii_byte(file)}, {get_char_width(image_file) + args.width})
				#incbin "{file}"
			'''))
		else:
			outfile.write(textwrap.dedent(f'''\

				ALIGN 4
				{args.name}FontEntryNumber{i}:
				FontEntry({args.name}FontEntryNumber{i+1}, {get_ascii_byte(file)}, {get_char_width(image_file) + args.width})
				#incbin "{file}"
			'''))
		i+=1
