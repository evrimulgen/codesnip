{
  * FirstRun.UUpdateDBase.pas
  *
  * Pascal script for use in [Code] Section of CodeSnip's Install.iss.
  *
  * Copies existing CodeSnip main and user databases from an original location
  * to location required by current version of CodeSnip.
  *
  * $Rev$
  * $Date$
  *
  * ***** BEGIN LICENSE BLOCK *****
  *
  * Version: MPL 1.1
  *
  * The contents of this file are subject to the Mozilla Public License Version
  * 1.1 (the "License"); you may not use this file except in compliance with the
  * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
  *
  * Software distributed under the License is distributed on an "AS IS" basis,
  * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  * the specific language governing rights and limitations under the License.
  *
  * The Original Code is FirstRun.UUpdateDBase.pas, formerly UpdateDBase.ps.
  *
  * The Initial Developer of the Original Code is Peter Johnson
  * (http://www.delphidabbler.com/).
  *
  * Portions created by the Initial Developer are Copyright (C) 2008-2012 Peter
  * Johnson. All Rights Reserved.
  *
  * Contributors:
  *    NONE
  *
  * ***** END LICENSE BLOCK *****
}

// Copies all files from one directory for another. Does nothing if SourceDir
// doesn't exist or if both directories are the same. If DestDir does not exist
// it is created.
procedure CopyDirectory(SourceDir, DestDir: string);
var
  SourcePath: string;
  DestPath: string;
  FindRec: TFindRec;
begin
  if CompareText(SourceDir, DestDir) = 0 then
    Exit;
  if not DirExists(SourceDir) then
    Exit;
  if not DirExists(DestDir) then
    ForceDirectories(DestDir);
  SourcePath := AddBackslash(SourceDir);
  DestPath := AddBackslash(DestDir);
  if FindFirst(SourcePath + '*', FindRec) then
  begin
    repeat
      if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      begin
        FileCopy(SourcePath + FindRec.Name, DestPath + FindRec.Name, False);
      end;
    until not FindNext(FindRec);
    FindClose(FindRec);
  end;
end;

// Copies both main and (where it exists) user databases from location they are
// in on installation identified by PrevInstallID to correct location for
// directory being installed.
procedure CopyDatabases(PrevInstallID: Integer);
var
  OldMainDatabase: string;
  OldUserDatabase: string;
begin
  OldMainDatabase := gMainDatabaseDirs[PrevInstallID];
  if OldMainDatabase <> '' then
    CopyDirectory(OldMainDatabase, gMainDatabaseDirs[piCurrent]);
  OldUserDatabase := gUserDatabaseDirs[PrevInstallID];
  if OldUserDatabase <> '' then
    CopyDirectory(OldUserDatabase, gUserDatabaseDirs[piCurrent]);
end;

// Checks if main database is installed in correct install directory for
// current version of program.
function MainDatabaseExists: Boolean;
begin
  Result := FileExists(gMainDatabaseDirs[piCurrent] + '\categories.ini');
end;

