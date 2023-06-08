import serial
import cv2

import PySimpleGUI as sg
import os.path
import PIL.Image
import io
import base64
import cv2
import numpy as np
# ------------------------------- Define Layout -------------------------------
##################################################################################################################
col1 =       [[sg.Text('Switch System', size=(15, 1), justification='center', font=("Helvetica", 25), relief=sg.RELIEF_RIDGE)],
             [sg.HorizontalSeparator()],
             
             [sg.Text('1:'),sg.Ok('reset',tooltip='Click to submit this window',key='-1-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('s:'),sg.Ok('FSBM/TRACK switch',tooltip='Click to submit this window',key='-s-')],
             [sg.HorizontalSeparator()]]
##################################################################################################################
col2 =       [[sg.Text('Skin/Red Tracking', size=(15, 1), justification='center', font=("Helvetica", 25), relief=sg.RELIEF_RIDGE)],
             [sg.HorizontalSeparator()],
             
             [sg.Text('q:'),sg.Ok('box open',tooltip='Click to submit this window',key='-q-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('w:'),sg.Ok('SKIN/RED switch',tooltip='Click to submit this window',key='-w-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('e:'),sg.Ok('color background',tooltip='Click to submit this window',key='-e-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('r:'),sg.Ok('stop',tooltip='Click to submit this window',key='-r-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('t:'),sg.Ok('write previous',tooltip='Click to submit this window',key='-t-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('y:'),sg.Ok('write current',tooltip='Click to submit this window',key='-y-')],
             [sg.HorizontalSeparator()],
             
             [sg.Text('u:'),sg.Ok('threshold red/skin',tooltip='Click to submit this window',key='-u-')],
             [sg.HorizontalSeparator()]]             
##################################################################################################################
col3 =       [[sg.Text('FSBM', size=(15, 1), justification='center', font=("Helvetica", 25), relief=sg.RELIEF_RIDGE)], 
             [sg.HorizontalSeparator()],
             
            
             [sg.Text('2:'),sg.Ok('tb(16x16)/sw(64x64)',tooltip='Click to submit this window',key='-2-')],
             [sg.HorizontalSeparator()],
              
             [sg.Text('3:'),sg.Ok('switch (tb16x16>>tb4x4) or (sw64x64>>sw7x7)',tooltip='Click to submit this window',key='-3-')],
             [sg.HorizontalSeparator()],
               
             [sg.Text('4:'),sg.Ok('tb4x4(4)',tooltip='Click to submit this window',key='-4-')],
             [sg.HorizontalSeparator()]]
##################################################################################################################
# ---------------------------------- Full layout ----------------------------------------------------------------------------------------------------------------
layout = [[sg.Column(col1, element_justification='c'),
           sg.VSeperator(),
           sg.Column(col2, element_justification='c'),
           sg.VSeperator(),
           sg.Column(col3, element_justification='c')]]
# --------------------------------- Create Window ---------------------------------------------------------------------------------------------------------------
window = sg.Window('Object controll', layout,resizable=True)
# ---------------------------------- Event Loop -----------------------------------------------------------------------------------------------------------------
ser = serial.Serial('COM4', baudrate=115200, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE)
cv2.namedWindow('Switch') #


while True:
    event, values = window.read()
    if event in (sg.WIN_CLOSED, 'Exit'):
        break
    if event == sg.WIN_CLOSED or event == 'Exit':
        break

##################################################################################################################
    if event == '-s-':       #switch from sw to tb(16x16>>>64x64)
        print('s')
        cmd_byte = b'\x50'    
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-q-':       #box grey
        print('q')
        cmd_byte = b'\x60'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-w-':       #skin/red switch  
        print('w')
        cmd_byte = b'\x70'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-e-':       #detect area background
        print('e')
        cmd_byte = b'\x80'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-r-':       #stop
        print('r')
        cmd_byte = b'\x90'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-t-':       #write box 1 data to ram(64x64) 
        print('t')
        cmd_byte = b'\xa0'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-y-':       #write box 2 data to ram(16x16)
        print('y')
        cmd_byte = b'\xb0'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-u-':       #switch box gray to skin/red 
        print('u')
        cmd_byte = b'\xc0'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-1-':        #reset
        print('1')
        cmd_byte = b'\x10'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-2-':       #switch from sw to tb(16x16>>>64x64) 
        print('2')
        cmd_byte = b'\x20'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-3-':       #switch from (tb16x16>>tb4x4    &&    sw64x64>>sw7x7) 
        print('3')
        cmd_byte = b'\x30'
        ser.write(cmd_byte)
##################################################################################################################
    if event == '-4-':       #switch from sw to tb(4x4>>>7x7) 
        print('4')
        cmd_byte = b'\x40'
        ser.write(cmd_byte)


# --------------------------------- Close & Exit ----------------------------------------------------------------------------------------------------------------
window.close()
cv2.destroyAllWindows() #close window
ser.close()

