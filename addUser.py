# -*- coding: utf-8 -*-
"""
Created on Thu Jan 24 19:59:48 2019

@author: blizn
"""

import tkinter 
import tkinter.messagebox as tm


       
class LoginFrame(Frame):
    def __call__(self, entry1, entry2):
        super().__call__(master)

        self.label_username = Label(self, text="Username")
        self.label_password = Label(self, text="Password")

        self.entry_username = Entry(self)
        self.entry_password = Entry(self, show="*")

        self.label_username.grid(row=0, sticky=E,ipadx= 10, pady= 10)
        self.label_password.grid(row=1, sticky=E,ipadx= 10, pady= 10)
        self.entry_username.grid(row=0, column=1, ipadx= 10, pady= 10)
        self.entry_password.grid(row=1, column=1,ipadx= 10, pady= 10)

        self.checkbox = Checkbutton(self, text="Keep me logged in")
        self.checkbox.grid(columnspan=2, ipadx= 10, pady= 10)

        self.logbtn = Button(self, text="Login", command=self._login_btn_clicked)
        self.logbtn.grid(columnspan=2,ipadx= 10, pady= 10)

        self.pack()
        self.place(bordermode=OUTSIDE, x= 300, y=200, height=200, width=200)

   
    def _login_btn_clicked(self):
        # print("Clicked")
        username = self.entry_username.get()
        password = self.entry_password.get()

        # print(username, password)

        if username == "john" and password == "password":
            tm.showinfo("Login info", "Welcome John")
        else:
            tm.showerror("Login error", "Incorrect username")
