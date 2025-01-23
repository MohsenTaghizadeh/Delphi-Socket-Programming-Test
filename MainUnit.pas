unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Inifiles, System.Win.ScktComp, IdBaseComponent,
  IdComponent, IdRawBase, IdRawClient, IdIcmpClient, Vcl.Grids, System.StrUtils;

type
  SendObject = record
    Panel: TPanel;
    Edt: TEdit;
    Btn_Send: TButton;
    Btn_Delete: TButton;
  end;

  ServerClient = record
    Panel: TPanel;
    ClientSocket: TCustomWinSocket;
    ChBox: TCheckBox;
    lbl: TLabel;
    Btn_Disconnect: TButton;
  end;

  TForm1 = class(TForm)
    PageControl: TPageControl;
    TcpClient: TTabSheet;
    TcpServer: TTabSheet;
    IdIcmpClient: TIdIcmpClient;
    pnl_Main: TPanel;
    pnl1: TPanel;
    Grp_Client: TGroupBox;
    List_Client: TStringGrid;
    pnl2: TPanel;
    pnl_TCP: TPanel;
    btn_Connect: TBitBtn;
    btn_Ping: TBitBtn;
    Edt_IP: TLabeledEdit;
    Edt_Port: TLabeledEdit;
    scrlbx_Client: TScrollBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Grp_Server: TGroupBox;
    List_Server: TStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    btn_Listen: TBitBtn;
    Edt_Server_Port: TLabeledEdit;
    scrlbx_Server: TScrollBox;
    Btn_Server_AddText: TBitBtn;
    btn_Client_AddText: TBitBtn;
    ClientSocket: TClientSocket;
    ServerSocket: TServerSocket;
    Grp_Server_Clients: TGroupBox;
    procedure btn_Client_AddTextClick(Sender: TObject);
    procedure scrlbx_ClientMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_ConnectClick(Sender: TObject);
    procedure edt_IPKeyPress(Sender: TObject; var Key: Char);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure btn_PingClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure btn_ListenClick(Sender: TObject);
    procedure ServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketThreadEnd(Sender: TObject;
      Thread: TServerClientThread);
    procedure ServerSocketThreadStart(Sender: TObject;
      Thread: TServerClientThread);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);

  private
    Sendobjects: TArray<SendObject>;
    ServerClients: TArray<ServerClient>;
    ObjectActive: SendObject;
    procedure AddSendObject(PageIndex: Integer; Txt: string);

    procedure Btn_SendClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Edt_KeyPress(Sender: TObject; var Key: Char);

    function FindObjectActive(Sender: TObject): Integer;

    procedure Write2IniFile(FileName, Section, Ident, Value: string);
    procedure DeleteIdentIniFile(FileName, Section, Ident: string);
    function ReadFromIniFile(FileName, Section, Ident: string): string;
    procedure ReadSectionIniFile(var Lst_SubmittedText: TStringList;
      FileName, Section: string);

    procedure AddText2List(StrGrid: TStringGrid; SendOrReceive, str: string);

    procedure ShowServerClients(Socket: TCustomWinSocket);
    procedure DeleteServerClients(Tag: Integer);
    procedure Btn_DisconnectServerClientClick(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Common_Unit;

{$R *.dfm}

procedure TForm1.btn_ConnectClick(Sender: TObject);
begin
  if ClientSocket.Active then
  begin
    AddText2List(List_Client, Txt_Send, 'Connection closing...');
    ClientSocket.Close;
  end
  else
  begin
    if Edt_IP.Text = '' then
    begin
      Edt_IP.SetFocus;
      Exit;
    end;
    if Edt_Port.Text = '' then
    begin
      Edt_Port.SetFocus;
      Exit;
    end;
    try
      Screen.Cursor := crHourGlass;
      try
        AddText2List(List_Client, Txt_Send, 'Connecting to ' + Edt_IP.Text
          + ' ...');
        ClientSocket.Host := Edt_IP.Text;
        ClientSocket.Port := StrToInt(Edt_Port.Text);
        ClientSocket.Open();
      except
      end;
    finally
    end;
  end;
end;

procedure TForm1.AddSendObject(PageIndex: Integer; Txt: string);
var
  I, Tag: Integer;
begin
  I := Length(Sendobjects);
  Tag := 0;
  if I > 0 then
    Tag := Sendobjects[I - 1].Panel.Tag;

  SetLength(Sendobjects, Length(Sendobjects) + 1);

  with Sendobjects[I] do
    try
      Tag := Tag + 1;

      if PageIndex = TcpClient.TabIndex then
      begin
        Panel := TPanel.Create(scrlbx_Client);
        Panel.Parent := scrlbx_Client
      end
      else
      begin
        Panel := TPanel.Create(scrlbx_Server);
        Panel.Parent := scrlbx_Server;
      end;

      Panel.AlignWithMargins := True;
      Panel.Margins.Left := 0;
      Panel.Margins.Right := 0;
      Panel.Margins.Top := 3;
      Panel.Margins.Bottom := 0;

      Panel.Visible := True;
      Panel.Top := I * 25;
      Panel.Align := alTop;
      Panel.Tag := Tag;
      Panel.Height := 25;

      Btn_Send := TButton.Create(Sendobjects[I].Panel);
      Btn_Send.Parent := Sendobjects[I].Panel;
      Btn_Send.Visible := True;
      Btn_Send.Width := 50;
      Btn_Send.Caption := 'Send'; // + IntToStr(Tag);
      Btn_Send.Tag := Tag;
      Btn_Send.Align := alRight;
      Btn_Send.OnClick := Btn_SendClick;

      Btn_Delete := TButton.Create(Sendobjects[I].Panel);
      Btn_Delete.Parent := Sendobjects[I].Panel;
      Btn_Delete.Visible := True;
      Btn_Delete.Width := 15;
      Btn_Delete.Caption := 'x';
      Btn_Delete.Tag := Tag;
      Btn_Delete.Align := alLeft;
      Btn_Delete.OnClick := Btn_DeleteClick;

      Edt := TEdit.Create(Sendobjects[I].Panel);
      Edt.Parent := Sendobjects[I].Panel;
      Edt.Visible := True;
      Edt.Align := alClient;
      Edt.Text := Txt;
      Edt.Tag := Tag;
      Edt.OnKeyPress := Edt_KeyPress;
    finally
      if PageIndex = TcpClient.TabIndex then
      begin
        Write2IniFile(FileName_IniFile, Section_Client_SubmittedText,
          IntToStr(I), Txt);
      end
      else
      begin
        Write2IniFile(FileName_IniFile, Section_Server_SubmittedText,
          IntToStr(I), Txt);
      end;
    end;
end;

procedure TForm1.AddText2List(StrGrid: TStringGrid; SendOrReceive, str: string);
var
  I: Integer;
begin
  if SendOrReceive = Txt_Send then
  begin
    StrGrid.RowCount := StrGrid.Tag + 1;
    StrGrid.Cells[1, StrGrid.Tag] := str;
    StrGrid.Cells[0, StrGrid.Tag] := IntToStr(StrGrid.Tag);
    StrGrid.Row := StrGrid.Tag;
    StrGrid.Tag := StrGrid.Tag + 1;
  end
  else
  begin
    if (StrGrid.Cells[1, StrGrid.Tag - 1] <> '') and
      (StrGrid.Cells[2, StrGrid.Tag - 1] = '') then
    begin
      StrGrid.Cells[2, StrGrid.Tag - 1] := str;
    end
    else
    begin
      StrGrid.RowCount := StrGrid.Tag + 1;

      StrGrid.Cells[2, StrGrid.Tag] := str;
      StrGrid.Cells[0, StrGrid.Tag] := IntToStr(StrGrid.Tag);
      StrGrid.Row := StrGrid.Tag;

      StrGrid.Tag := StrGrid.Tag + 1;
    end;
  end;
  Postmessage(StrGrid.Handle, WM_VSCROLL, 1, 0);
  // down
end;

procedure TForm1.btn_Client_AddTextClick(Sender: TObject);
begin
  AddSendObject(PageControl.TabIndex, '');
end;

procedure TForm1.Btn_DeleteClick(Sender: TObject);
var
  Index: Integer;
  len: Integer;
begin
  Index := FindObjectActive(Sender);
  ObjectActive.Edt.Free;
  ObjectActive.Btn_Send.Free;
  ObjectActive.Btn_Delete.Free;
  ObjectActive.Panel.Free;
  Move(Sendobjects[Index + 1], Sendobjects[Index], SizeOf(Sendobjects[0]) *
    (Length(Sendobjects) - Index - 1));

  len := Length(Sendobjects);
  SetLength(Sendobjects, len - 1);

  DeleteIdentIniFile(FileName_IniFile, Section_Client_SubmittedText,
    IntToStr(len - 1));
end;

procedure TForm1.Btn_DisconnectServerClientClick(Sender: TObject);
var
  tag, I: Integer;
begin
  tag := (Sender as TComponent).Tag;
  for I := 0 to Length(ServerClients) - 1 do
  begin
    if ServerClients[I].Panel.Tag = tag then
    begin
      AddText2List(List_Server, Txt_Receive, 'Client ' + ServerClients[i].ClientSocket.RemoteAddress + ' (' + inttostr(ServerClients[i].ClientSocket.SocketHandle) + ') Disconnected');
      ServerClients[i].ClientSocket.Destroy;

      DeleteServerClients(tag);
      Break;
    end;
  end;
end;

procedure TForm1.btn_ListenClick(Sender: TObject);
begin
  if ServerSocket.Active then
  begin
    AddText2List(List_Server, Txt_Send, 'End of listening...');

    btn_Listen.Font.Color := clGreen;
    btn_Listen.Caption := 'Listen';

    ServerSocket.Close();
  end
  else
  begin
    if Edt_Server_Port.Text = '' then
    begin
      Edt_Server_Port.SetFocus;
      Exit;
    end;

    Screen.Cursor := crHourGlass;
    try
      AddText2List(List_Server, Txt_Send, 'Start Listening ...');
      ServerSocket.Port := StrToInt(Edt_Server_Port.Text);

      Write2IniFile(FileName_IniFile, Section_Server, Ident_Server_LastPort,
        Edt_Server_Port.Text);

      ServerSocket.Open();
    except
      on E: Exception do
      begin
        Screen.Cursor := crDefault;

        AddText2List(List_Server, Txt_Receive,
          'Error: Port number already used.');

        Edt_Server_Port.SetFocus;
      end;
    end;
  end;
end;

procedure TForm1.btn_PingClick(Sender: TObject);
begin
  if Edt_IP.Text = '' then
  begin
    Edt_IP.SetFocus;
    Exit;
  end;
  if Edt_Port.Text = '' then
  begin
    Edt_Port.SetFocus;
    Exit;
  end;
  try
    AddText2List(List_Client, Txt_Send, 'Pinging ' + Edt_IP.Text);
    Screen.Cursor := crHourGlass;
    try
      IdIcmpClient.Host := Edt_IP.Text;
      IdIcmpClient.Ping();
      if IdIcmpClient.ReplyStatus.BytesReceived > 0 then;
      AddText2List(List_Client, Txt_Receive, 'Received the answer');
    except
      AddText2List(List_Client, Txt_Receive, 'Not received the answer');
    end;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TForm1.Btn_SendClick(Sender: TObject);
var
  str: string;
  Number, I: Integer;
begin
  Number := FindObjectActive(Sender);
  str := ObjectActive.Edt.Text;

  if PageControl.TabIndex = TcpClient.TabIndex then
  begin
    if not ClientSocket.Socket.Connected then
    begin
      btn_Connect.SetFocus;
      Exit;
    end;
    if Trim(str) <> '' then
    begin
      ClientSocket.Socket.SendText(str);
      AddText2List(List_Client, Txt_Send, str);

      Write2IniFile(FileName_IniFile, Section_Client_SubmittedText,
        IntToStr(Number), str);
    end
    else
    begin
      ObjectActive.Edt.SetFocus;
    end;
  end
  else
  begin
    if Length(ServerClients) = 0 then
    begin
      btn_Listen.SetFocus;
      Exit;
    end;

    if Trim(str) <> '' then
    begin
      for I := 0 to Length(ServerClients) - 1 do
      begin
        if ServerClients[I].ChBox.Checked then
        begin
          ServerClients[I].ClientSocket.SendText(str);
          AddText2List(List_Server, Txt_Send,
          ServerClients[I].ClientSocket.RemoteAddress + ' ('+ IntToStr(ServerClients[I].ClientSocket.SocketHandle) + '): ' + str);
        end;
      end;

      Write2IniFile(FileName_IniFile, Section_Server_SubmittedText,
        IntToStr(Number), str);
    end
    else
    begin
      ObjectActive.Edt.SetFocus;
    end;



  end;
end;

procedure TForm1.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Screen.Cursor := crDefault;

  btn_Connect.Font.Color := clRed;
  btn_Connect.Caption := 'Disconnect';

  AddText2List(List_Client, Txt_Receive, 'Connected to ' + Edt_IP.Text + '...');
  Write2IniFile(FileName_IniFile, Section_Client, Ident_Client_LastIP,
    Edt_IP.Text);
  Write2IniFile(FileName_IniFile, Section_Client, Ident_Client_LastPort,
    Edt_Port.Text);
end;

procedure TForm1.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Screen.Cursor := crDefault;
  btn_Connect.Font.Color := clGreen;
  btn_Connect.Caption := 'Connect';
  AddText2List(List_Client, Txt_Receive, 'Connection closed');
end;

procedure TForm1.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  ErrCode: Integer;
begin
  ErrCode := ErrorCode;
  ErrorCode := 0;
  Screen.Cursor := crDefault;
  AddText2List(List_Client, Txt_Receive, 'Socket error ' + IntToStr(ErrCode));
end;

procedure TForm1.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  ReceiveText: string;
begin
  ReceiveText := Socket.ReceiveText();
  AddText2List(List_Client, Txt_Receive, ReceiveText);
end;

procedure TForm1.DeleteIdentIniFile(FileName, Section, Ident: string);
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FileName);
    try
      IniFile.DeleteKey(Section, Ident);
    finally
      IniFile.Free;
    end;
  except

  end;
end;

procedure TForm1.DeleteServerClients(Tag: Integer);
var
  I: Integer;
begin
  for I := 0 to Length(ServerClients) - 1 do
  begin
    if ServerClients[I].Panel.Tag = Tag then
    begin
      //ServerClients[i].ClientSocket.Free;
      ServerClients[i].lbl.Free;
      ServerClients[i].ChBox.Free;
      ServerClients[i].Btn_Disconnect.Free;
      ServerClients[i].Panel.Free;

      Move(ServerClients[I + 1], ServerClients[I], SizeOf(ServerClients[0]) *
        (Length(ServerClients) - I - 1));

      SetLength(ServerClients, Length(ServerClients) - 1);

      Break;
    end;
  end;


end;

procedure TForm1.edt_IPKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', '.', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TForm1.Edt_KeyPress(Sender: TObject; var Key: Char);
begin
  FindObjectActive(Sender);
  if Key = #13 then
  begin
    ObjectActive.Btn_Send.Click;
  end;
end;

function TForm1.FindObjectActive(Sender: TObject): Integer;
var
  Number, I: Integer;
begin
  Number := (Sender as TComponent).Tag;
  for I := 0 to Length(Sendobjects) - 1 do
  begin
    if Sendobjects[I].Panel.Tag = Number then
    begin
      ObjectActive := Sendobjects[I];
      Result := I;
      Break;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Cmd: string;
  I: Integer;
  Lst_SubmittedText, Lst_Delimiter: TStringList;
begin
  Grp_Client.Width := Form1.Width div 2;
  Grp_Server.Width := Form1.Width div 2;

  // TextPlacementRow:
  List_Client.Tag := 1;
  List_Server.Tag := 1;

  List_Client.Cells[1, 0] := 'Send';
  List_Client.Cells[2, 0] := 'Receive';

  List_Server.Cells[1, 0] := 'Send';
  List_Server.Cells[2, 0] := 'Receive';

  Edt_IP.Text := ReadFromIniFile(FileName_IniFile, Section_Client,
    Ident_Client_LastIP);
  Edt_Port.Text := ReadFromIniFile(FileName_IniFile, Section_Client,
    Ident_Client_LastPort);

  Edt_Server_Port.Text := ReadFromIniFile(FileName_IniFile, Section_Server,
    Ident_Server_LastPort);

  Lst_SubmittedText := TStringList.Create;
  try
    // Read Text For Client:
    ReadSectionIniFile(Lst_SubmittedText, FileName_IniFile,
      Section_Client_SubmittedText);
    if Lst_SubmittedText.Count = 0 then
    begin
      AddSendObject(TcpClient.TabIndex, '');
      Exit;
    end;

    for I := 0 to Lst_SubmittedText.Count - 1 do
    begin
      Lst_Delimiter := TStringList.Create;
      try
        Lst_Delimiter.Delimiter := '=';
        Lst_Delimiter.DelimitedText := Lst_SubmittedText[I];

        AddSendObject(TcpClient.TabIndex, Lst_Delimiter[1]);

      finally
        Lst_Delimiter.Free;
      end;
    end;

    // Read Text For Client:
    Lst_SubmittedText.Clear();
    ReadSectionIniFile(Lst_SubmittedText, FileName_IniFile,
      Section_Server_SubmittedText);
    if Lst_SubmittedText.Count = 0 then
    begin
      AddSendObject(TcpServer.TabIndex, '');
      Exit;
    end;

    for I := 0 to Lst_SubmittedText.Count - 1 do
    begin
      Lst_Delimiter := TStringList.Create;
      try
        Lst_Delimiter.Delimiter := '=';
        Lst_Delimiter.DelimitedText := Lst_SubmittedText[I];

        AddSendObject(TcpServer.TabIndex, Lst_Delimiter[1]);

      finally
        Lst_Delimiter.Free;
      end;
    end;
  finally
    Lst_SubmittedText.Free;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Length(Sendobjects) - 1 do
  begin
    Sendobjects[I].Edt.Free;
    Sendobjects[I].Btn_Send.Free;
    Sendobjects[I].Btn_Delete.Free;
    Sendobjects[I].Panel.Free;
  end;

end;

procedure TForm1.FormResize(Sender: TObject);
var
  w: Integer;
begin

  if PageControl.TabIndex = TcpClient.TabIndex then
    w := Grp_Client.Width
  else
    w := Grp_Server.Width;

  List_Client.DefaultColWidth := w div 2 - 30;
  List_Client.ColWidths[0] := 50;

  List_Server.DefaultColWidth := w div 2 - 30;
  List_Server.ColWidths[0] := 50;
end;

function TForm1.ReadFromIniFile(FileName, Section, Ident: string): string;
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FileName);
    try
      Result := IniFile.ReadString(Section, Ident, '');
    finally
      IniFile.Free;
    end;
  except
  end;
end;

procedure TForm1.ReadSectionIniFile(var Lst_SubmittedText: TStringList;
  FileName, Section: string);
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FileName);
    try
      IniFile.ReadSectionValues(Section, Lst_SubmittedText);
    finally
      IniFile.Free;
    end;
  except
  end;
end;

procedure TForm1.scrlbx_ClientMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta > 0 then
    Postmessage(scrlbx_Client.Handle, WM_VSCROLL, 0, 0); // up
  if WheelDelta < 0 then
    Postmessage(scrlbx_Client.Handle, WM_VSCROLL, 1, 0); // down
end;

procedure TForm1.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  AddText2List(List_Server, Txt_Receive, 'Client ' + Socket.RemoteAddress + ' (' + inttostr(Socket.SocketHandle) + ') Connected');
  ShowServerClients(Socket);
end;

procedure TForm1.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
    AddText2List(List_Server, Txt_Receive, 'Client ' + Socket.RemoteAddress + ' (' + inttostr(Socket.SocketHandle) + ') Disconnected');
  DeleteServerClients(Socket.SocketHandle);
end;

procedure TForm1.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  AddText2List(List_Server, Txt_Receive, 'Error ' +IntToStr(ErrorCode));
end;

procedure TForm1.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Txt, TxtSend: string;
begin
  AddText2List(List_Server, Txt_Receive,'Client ' + Socket.RemoteAddress  + '(' + IntToStr(Socket.SocketHandle) + '): ' + Socket.ReceiveText);
end;

procedure TForm1.ServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  Screen.Cursor := crDefault;

  if ServerSocket.Active then
  begin
    // AddText2List(List_Server, Txt_Send, 'Start of listening...');

    btn_Listen.Font.Color := clRed;
    btn_Listen.Caption := 'Stop';
  end;

  Write2IniFile(FileName_IniFile, Section_Server, Ident_Server_LastPort,
    Edt_Server_Port.Text);
end;

procedure TForm1.ServerSocketThreadEnd(Sender: TObject;
  Thread: TServerClientThread);
begin
  btn_Listen.Font.Color := clGreen;
  btn_Listen.Caption := 'Listen';

end;

procedure TForm1.ServerSocketThreadStart(Sender: TObject;
  Thread: TServerClientThread);
begin
  btn_Listen.Font.Color := clGreen;
  btn_Listen.Caption := 'Listen';
end;

procedure TForm1.ShowServerClients(Socket: TCustomWinSocket);
var
  I, Tag, h: Integer;
begin
  h := 20;
  I := Length(ServerClients);
  Tag := 0;
  if I > 0 then
    Tag := ServerClients[I - 1].Panel.Tag;

  SetLength(ServerClients, Length(ServerClients) + 1);

  with ServerClients[I] do
    try
      Tag := Socket.SocketHandle;
      ClientSocket := Socket;

      Panel := TPanel.Create(Grp_Server_Clients);
      Panel.Parent := Grp_Server_Clients;

      Panel.AlignWithMargins := True;
      Panel.Margins.Left := 0;
      Panel.Margins.Right := 0;
      Panel.Margins.Top := 3;
      Panel.Margins.Bottom := 0;

      Panel.Visible := True;
      Panel.Top := I * h;
      Panel.Align := alTop;
      Panel.Tag := Tag;
      Panel.Height := h;

      ChBox := TCheckBox.Create(ServerClients[I].Panel);
      ChBox.Parent := ServerClients[I].Panel;
      ChBox.Checked:= true;
      ChBox.Visible := True;
      ChBox.Width := 20;
      ChBox.Caption := ' '; // + IntToStr(Tag);
      ChBox.Tag := Tag;
      ChBox.Align := alLeft;

      Btn_Disconnect := TButton.Create(ServerClients[I].Panel);
      Btn_Disconnect.Parent := ServerClients[I].Panel;
      Btn_Disconnect.Visible := True;
      Btn_Disconnect.Width := 80;
      Btn_Disconnect.Caption := 'Disconnect';
      Btn_Disconnect.Font.Color := clRed;
      Btn_Disconnect.Tag := Tag;
      Btn_Disconnect.Align := alRight;
      Btn_Disconnect.OnClick := Btn_DisconnectServerClientClick;

      lbl := TLabel.Create(ServerClients[I].Panel);
      lbl.Parent := ServerClients[I].Panel;
      lbl.Visible := True;
      lbl.Align := alClient;
      lbl.Caption := Socket.RemoteAddress + ' (' + inttostr(Socket.SocketHandle) + ')';
      lbl.Tag := Tag;
    finally
    end;
end;

procedure TForm1.Write2IniFile(FileName, Section, Ident, Value: string);
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FileName);
    try
      IniFile.WriteString(Section, Ident, Value);
    finally
      IniFile.Free;
    end;
  except

  end;
end;

end.
