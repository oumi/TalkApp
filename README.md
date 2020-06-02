# inedithos_chat

Aplicación de chat



## Errores 
## 1 Error funciones 
Cuando se instalan las funciones con la página de arriba, da este error a la hora de hacer deploy

0 info it worked if it ends with ok
1 verbose cli [
1 verbose cli   'C:\\Program Files\\nodejs\\node.exe',
1 verbose cli   'C:\\Program Files\\nodejs\\node_modules\\npm\\bin\\npm-cli.js',
1 verbose cli   '--prefix',
1 verbose cli   'C:\\Users\\LBO880\\AndroidStudioProjects\\inedithos_chat\\functions',
1 verbose cli   'run',
1 verbose cli   'lint'
1 verbose cli ]
2 info using npm@6.13.7
3 info using node@v13.10.1
4 verbose run-script [ 'prelint', 'lint', 'postlint' ]
5 info lifecycle functions@~prelint: functions@
6 info lifecycle functions@~lint: functions@
7 verbose lifecycle functions@~lint: unsafe-perm in lifecycle true
8 verbose lifecycle functions@~lint: PATH: C:\Program Files\nodejs\node_modules\npm\node_modules\npm-lifecycle\node-gyp-bin;C:\Users\LBO880\AndroidStudioProjects\inedithos_chat\functions\node_modules\.bin;C:\ProgramData\Oracle\Java\javapath;C:\app\client\LBO880\product\12.1.0\client_1\bin;C:\app\LBO880\product\12.1.0\client_1;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files\TortoiseSVN\bin;C:\Program Files\Java\jdk1.6.0_25\bin;C:\Program Files\SlikSvn\bin\;C:\Program Files\AutoFirma\AutoFirma;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\Sennheiser\SoftphoneSDK\;C:\Program Files\Git\cmd;C:\Program Files\nodejs\;C:\Users\LBO880\AppData\Local\Microsoft\WindowsApps;C:\Users\LBO880\AppData\Local\GitHubDesktop\bin;C:\Users\LBO880\AppData\Roaming\npm
9 verbose lifecycle functions@~lint: CWD: C:\Users\LBO880\AndroidStudioProjects\inedithos_chat\functions
10 silly lifecycle functions@~lint: Args: [ '/d /s /c', 'eslint .' ]
11 silly lifecycle functions@~lint: Returned: code: 1  signal: null
12 info lifecycle functions@~lint: Failed to exec lint script
13 verbose stack Error: functions@ lint: `eslint .`
13 verbose stack Exit status 1
13 verbose stack     at EventEmitter.<anonymous> (C:\Program Files\nodejs\node_modules\npm\node_modules\npm-lifecycle\index.js:332:16)
13 verbose stack     at EventEmitter.emit (events.js:316:20)
13 verbose stack     at ChildProcess.<anonymous> (C:\Program Files\nodejs\node_modules\npm\node_modules\npm-lifecycle\lib\spawn.js:55:14)
13 verbose stack     at ChildProcess.emit (events.js:316:20)
13 verbose stack     at maybeClose (internal/child_process.js:1026:16)
13 verbose stack     at Process.ChildProcess._handle.onexit (internal/child_process.js:286:5)
14 verbose pkgid functions@
15 verbose cwd C:\Users\LBO880\AndroidStudioProjects\inedithos_chat
16 verbose Windows_NT 10.0.18362
17 verbose argv "C:\\Program Files\\nodejs\\node.exe" "C:\\Program Files\\nodejs\\node_modules\\npm\\bin\\npm-cli.js" "--prefix" "C:\\Users\\LBO880\\AndroidStudioProjects\\inedithos_chat\\functions" "run" "lint"
18 verbose node v13.10.1
19 verbose npm  v6.13.7
20 error code ELIFECYCLE
21 error errno 1
22 error functions@ lint: `eslint .`
22 error Exit status 1
23 error Failed at the functions@ lint script.
23 error This is probably not a problem with npm. There is likely additional logging output above.
24 verbose exit [ 1, true ]

## Solución
Eliminar "npm --prefix \"$RESOURCE_DIR\" run lint" de 'firebase.json'
Queda asi
{
  "functions": {
    "predeploy": [
    ],
    "source": "functions"
  }
}


## 2 Error flutter no se reconoce como un comando interno o externo
https://stackoverflow.com/questions/49609889/flutter-doctor-doesnt-work-on-neither-command-prompt-or-powershell-window

## Desarrollo 
##Notificaciones 

Para las notificaciones, primero hay que instalar nodejs para poder utilizar las parte de "firebase functions" que están en javascript. 
Hay que seguir las recomendaciones de la siguiente página: 
https://firebase.google.com/docs/functions/get-started?fbclid=IwAR0HvmcTILsjCHVXqJgUjGlWCWwiWU4Dy0dR3aAeLIKaDXjWLUF4rwCc-7w

o bien pimero instalar node a partir de este video:
https://www.youtube.com/watch?v=F41Y-rpdlVM
y de alli ya seguir para el firebase-tools en la página de arriba.

## Crear nuevo proyecto firebase y preparación del entorno:
- Primero, creamos un nuevo proyecto con el nombre del id que esta en android gradle
- Luego, habilitamos en authentication--> sign in method: email/password: enabled
-  Cambiar en Database los rules a 
--------------------------------------------
{
  "rules": {
    ".read": "auth !=null",
      "conversations": {
            ".write": "auth != null"
          },
            
      "messages": {
            ".write": "auth != null"
          },
               
      "users": {
        "$uid":{
          ".write": "$uid === auth.uid"
        },
         
      },
  },
}
- Configurar CLoud Storage 
Hay que configurar cloud storage estbleciendo reglas para la escritura y lectura que en este caso solo se permite para usuarios autenticados. Tambien, se establece una ubicación que indica donde se almacenarán los segmentos predeterminados de cloud storage y sus datos, que en este caso es ‘eur3’ que se refiere a Europa.


 - Añadir el servicio a la aplicación en desarrollo 
 Para el registro de la aplicación en firebase, se siguen los siguientes pasos. https://firebase.google.com/docs/android/setup
 
 

