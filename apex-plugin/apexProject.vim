" This file is part of vim-force.com plugin
"   https://github.com/neowit/vim-force.com
" File: apexProject.vim
" Last Modified: 2014-05-06
" Author: Alejandro De Gregorio 
" Maintainers: Alejandro De Gregorio, Andrey Gavrikov
"
" Main actions: Initialize a new Apex Project asking the user for the org information
"
if exists("g:loaded_apexProject") || &compatible
  finish
endif
let g:loaded_apexProject = 1

function apexProject#init()
	let projectName = apexProject#askInput('Enter project name: ')
	let l:projectSrcPath = apexOs#joinPath(projectName, 'src')
	let l:classesDirPath = apexOs#joinPath(l:projectSrcPath, 'classes')
	call apexOs#createDir(l:classesDirPath)

	call apexProject#buildPropertiesFile(projectName)
	call apexProject#buildPackageFile(projectName)

	call apexTooling#refreshProject(l:projectSrcPath, 1)
	" check if we have existing files to open
	let fullPaths = apexOs#glob(l:projectSrcPath . "**/*.cls")
	if len(fullPaths) > 0
		"open random class from just loaded files
		execute 'e ' . fnameescape(fullPaths[0])
	else
		":ApexNewFile
		call apexMetaXml#createFileAndSwitch(l:projectSrcPath)
	endif
	
endfunction

function apexProject#buildPropertiesFile(projectName)
	let propertiesFilePath = apexOs#joinPath([g:apex_properties_folder, a:projectName . '.properties'])
	let username = apexProject#askInput('Enter username: ')
	let password = apexProject#askSecretInput('Enter password: ')
	let token = apexProject#askInput('Enter security token: ')
	let orgType = apexProject#askInput('Enter org type (test|login): ')

	let fileLines = []
	call add(fileLines, 'sf.username = ' . username)
	call add(fileLines, 'sf.password = ' . password . token)
	call add(fileLines, 'sf.serverurl = https://' . orgType . '.salesforce.com')
	call writefile(fileLines, propertiesFilePath)
endfunction

" Ask the user for an input
" Param: message: A text to show to the user
" Param1: secret: (optional) 0 for false, anything else for true
function apexProject#askInput(message, ...)
	call inputsave()
	let secret = a:0 > 0 && a:1
	let value = secret ? inputsecret(a:message) : input(a:message)
	call inputrestore()
	return value
endfunction

function apexProject#askSecretInput(message)
	return apexProject#askInput(a:message, 1)
endfunction

function apexProject#buildPackageFile(projectName)
	let srcFolderPath = apexOs#joinPath([a:projectName, 'src'])
	let packageElements = ['ApexClass', 'ApexComponent', 'ApexPage', 'ApexTrigger', 'CustomLabels', 'Scontrol', 'StaticResource']
	let package = apexMetaXml#packageXmlNew()

	for element in packageElements
		call apexMetaXml#packageXmlAdd(package, element, ['*'])
	endfor

	call apexMetaXml#packageWrite(package, srcFolderPath)
endfunction