# Simple enough, just import everything from tkinter.
from tkinter import *
from tkinter import ttk
import connect
#import onlogin
from PIL import Image, ImageTk
import tkinter.messagebox as tm
import os
import hashlib
import sys
import datetime


       
class addUser(Frame):
    def __init__(self, pwd):
        #super().__init__(master)
        frame.__init__(self)
     
    def fields(self):
        self.label_pos = Label(self, text="Melyik pozi legyen?")
        
        cursor.execute("select p.posid, p.description ||' '|| l.description as description from C##HR.Position p, C##HR.Position_Level l where p.position_level = l.levelid",())
                
        things =  [{'posid': row[0], 'description': row[1]} for row in cursor.fetchall()]
        
        self.combobox_values = []
        print(things)
        for item in things:
            self.combobox_values.append(item['description'])
            
        self.list_posid = ttk.Combobox(self,width=30, text="position", values=self.combobox_values)
        self.label_pos.grid(row=0,column=0,sticky=E, padx=1, pady=5)
        self.list_posid.grid(row=0,column=1,sticky=E, ipadx=30, pady=5)
        
        #--------------------------------------------------------------------
        self.label_pwd = Label(self, text="Password: ")
        self.input_password = Entry(self, show="*")
        self.label_pwd.grid(row=1,column=0,sticky=E, padx=1, pady=5)
        self.input_password.grid(row=1,column=1,sticky=W, ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_firstname = Label(self, text="First name: ")
        self.input_firstname = Entry(self)
        self.label_firstname.grid(row=2,column=0,sticky=E, padx=1, pady=5)
        self.input_firstname.grid(row=2,column=1,sticky=W, ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_lastname = Label(self, text="Last name: ")
        self.input_lastname = Entry(self)
        self.label_lastname.grid(row=2,column=2,sticky=E, padx=1, pady=5)
        self.input_lastname.grid(row=2,column=3,sticky=W, ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_birth_date = Label(self, text="Birth date: ")
        self.input_birth_date = Entry(self)
        self.label_birth_date.grid(row=3,column=0,sticky=E, padx=1, pady=5)
        self.input_birth_date.grid(row=3,column=1,sticky=W, ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_birth_place = Label(self, text="Birth place: ")
        self.input_birth_place = Entry(self)
        self.label_birth_place.grid(row=3,column=2,sticky=E, padx=1, pady=5)
        self.input_birth_place.grid(row=3,column=3,sticky=W, ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_mother_name = Label(self, text="Mother name: ")
        self.input_mother_name = Entry(self)
        self.label_mother_name.grid(row=3,column=4,sticky=E, padx=50, pady=5)
        self.input_mother_name.grid(row=3,column=5,sticky=W, padx=1, pady=5)
        #--------------------------------------------------------------------
        self.label_address_const = Label(self, text="Állandó cím: ")
        self.input_address_const = Entry(self)
        self.label_address_const.grid(row=4,column=0,sticky=E,padx=1, pady=5)
        self.input_address_const.grid(row=4,column=1,sticky=W,ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_address_temp = Label(self, text="Levelezési cím: ")
        self.input_address_temp = Entry(self)
        self.label_address_temp.grid(row=4,column=2,sticky=E, padx=1, pady=5)
        self.input_address_temp.grid(row=4,column=3,sticky=W, ipadx=30, pady=5)
        #--------------------------------------------------------------------
        self.label_beginning_date = Label(self, text="Kezdés dátuma: ")
        self.input_beginning_date = Entry(self)
        self.label_beginning_date.grid(row=5,column=0,sticky=E, padx=1, pady=5)
        self.input_beginning_date.grid(row=5,column=1,sticky=W, ipadx=30, pady=5)
         #--------------------------------------------------------------------
        
        self.label_gender = Label(self, text="Neme: ")
         
        gender= [{'genderid':'F','desc':'Female'},{'genderid':'M','desc':'Male'}]
        self.gender_values = []
        for item in gender:
            print(item['desc'])
        
        for item in gender:
            self.gender_values.append(item['desc'])
            
        self.list_gender = ttk.Combobox(self,width=30, text="Neme", values=self.gender_values)
        self.label_gender.grid(row=6,column=0,sticky=E, padx=1, pady=5)
        self.list_gender.grid(row=6,column=1,sticky=E, ipadx=30, pady=5)
        
        #--------------------------------------------------------------------
        
        self.label_boss = Label(self, text="Vezető: ")
        
        cursor.execute("SELECT e.lastname || ' ' || e.firstname || ' - ' || posi.description AS boss FROM C##HR.Employee e, (SELECT p.posid, p.description || ' ' || l.description AS description FROM C##HR.Position p, C##HR.Position_Level l WHERE p.position_level = l.levelid) posi WHERE posi.posid = e.posid AND e.posid IN (SELECT ph.parent_id FROM C##HR.POSITION_HIERARCHY ph, C##HR.Position_Level pl WHERE pl.levelid = ph.child_id and ph.child_id = :1)",(1002,))
                
        boss = cursor.fetchone()
        #boss_values = []
        print(boss)
        #for item in boss:
        #    self.boss_values.append(boss[item])
            
        self.list_boss = ttk.Combobox(self,width=30, text="boss", values=boss)
        self.label_boss.grid(row=7,column=0,sticky=E, padx=1, pady=5)
        self.list_boss.grid(row=7,column=1,sticky=E, ipadx=30, pady=5)
        
        
        valid = 'VALID'
        
        self.saveUserBtn = Button(self, text="Save")# , command=self._insert_user(
               
        
        
        
        self.saveUserBtn.grid(row=8,column=0,sticky=E, ipadx=30, pady=50, columnspan=2)
        
        self.pack()
        self.place(bordermode=OUTSIDE, x= 10, y=10, height=800, width=1200)
        
        def hash_string(string):
            return hashlib.sha256(string.encode('utf-8')).hexdigest()
        
        def _password_check(pwd):
            if len(pwd) == 8:
                return hashlib.sha256(pwd.encode('utf-8')).hexdigest()
            else:
                tm.showerror("A jelszó legalább 8 karakter hosszú legyen!")
        
        def _isEmpty(String, objects):
            if not String:
                tm.showerror("A "+ objects +" mezőt kötelező kitölteni!")
        
        
        
        
class LoginFrame(Frame):
    def __init__(self):
        #super().__init__(master)
        frame.__init__(self)
     
    def login(self):
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


class Lazarus(Frame):

    def __init__(self, master=None):
        
        Frame.__init__(self, master) 
        #super().__init__(master)
        self.master = master
        self.init_window()

    #Creation of init_window
    def init_window(self):

        self.master.title("Lazarus v1.1.00")
        self.pack(fill=BOTH, expand=1)

        menu = Menu(self.master)
        self.master.config(menu=menu)
        global active_user
        active_user = ""
        file = Menu(menu,tearoff=0)
        
        file.add_command(label="Login", command=self.show_frame)
        file.add_command(label="Exit", command=self.client_exit)
        menu.add_cascade(label="File", menu=file)
        
        
        if len(active_user) == 0:
            
        # create the file object)
            user = Menu(menu,tearoff=0 )
    
            user.add_command(label="Add user", command = self.addUser)
            user.add_command(label="Modify user", command = self.showImg)
            user.add_command(label="Add user with all data", command = self.showImg)
            menu.add_cascade(label="User", menu=user)
    
            position=Menu(menu,tearoff=0)
            position.add_command(label="Add position", command = self.showImg)
            position.add_command(label="Modify position", command = self.showImg)
            menu.add_cascade(label='Position', menu=position)
            
            worktime=Menu(menu,tearoff=0)
            worktime.add_command(label="Attendance", command = self.showImg)
            menu.add_cascade(label='Work time', menu=worktime)
    
            diagram=Menu(menu,tearoff=0)
            diagram.add_command(label="Attendance statistic", command = self.showImg)
            diagram.add_command(label="Worktime statistic", command = self.showImg)
            diagram.add_command(label="lojalitás diagram", command = self.showImg)
            menu.add_cascade(label='Diagram', menu=diagram)
        
        
    def addUser(self):
        addUser.fields(self)
        self.tkraise()
    
    
    
    
    def showImg(self):
        self.grid_forget()
        load = Image.open("C:\\Users\\blizn\\Desktop\\18.jpg")
        render = ImageTk.PhotoImage(load)

        # labels can be text or images
        img = Label(self, image=render)
        img.image = render
        img.place(x=0, y=0)
        self.tkraise()


    def showText(self):
        self.pack_forget()
        self.grid_forget()
        text = Label(self, text="Hey there good lookin!")
        text.pack()
        self.tkraise()
        

    def client_exit(self):
        active_user = ""
        quit()
        
        
    def show_frame(self):
        '''Show a frame for the given page name'''
        LoginFrame.login(self)
        self.tkraise()
        
    def _login_btn_clicked(self):
        # print("Clicked")
        username = self.entry_username.get()
        password = self.entry_password.get()

        # print(username, password)
        def hash_string(string):
            return hashlib.sha256(string.encode('utf-8')).hexdigest()
        

        cursor.execute("select count(1) from C##HR.Employee e where e.username = :1 and e.pwd = :2 ",(username, hash_string(password),))
        count, = cursor.fetchone()
        print(hash_string(password))
        
        if int(count)  > 0 :
            tm.showinfo("Login info", "Welcome "+username+" in Lazarus")
            active_user = username
        else:
            tm.showerror("Login error", "Incorrect username or password")
            
        def _insert_user(self,pwd, lastname, firstname, gender, bd, bp, mb, ac, at, beginning_date,status, posid, superior):
            cursor.execute("begin pkg_user.add_user(p_pwd => :p_pwd, p_lastname => :p_lastname, p_firstname => :p_firstname, p_gender => :p_gender,p_birth_date => :p_birth_date,p_birth_place => :p_birth_place,p_mother_name => :p_mother_name,p_address_const => :p_address_const,p_address_temp => :p_address_temp,p_beginning_date => :p_beginning_date,p_status => :p_status,p_posid => :p_posid,p_superior => :p_superior); end"
                       ,(pwd, lastname, firstname, gender, bd, bp, mb,ac,at, beginning_date, status, posid, superior))
            addUser_out = cursor.fetchone()
        
            if int(addUser_out) == 0 :
                tm.showinfo("Sikeres rögzítés")
                active_user = username
            else:
                tm.showerror("Sikertelen rögzítés")

# root window created. Here, that would be the only window, but
# you can later have windows within windows.
windows = Tk()

windows.geometry("1200x800+300+300")

#creation of an instance
app = Lazarus(windows)
#3app1 = LoginFrame(windows)


#mainloop 
windows.mainloop()  