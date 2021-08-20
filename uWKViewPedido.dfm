object FormViewPedidos: TFormViewPedidos
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Pedidos'
  ClientHeight = 506
  ClientWidth = 899
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelChave: TPanel
    Left = 0
    Top = 0
    Width = 899
    Height = 61
    Align = alTop
    TabOrder = 0
    object ButtonNovoPedido: TButton
      Left = 0
      Top = 2
      Width = 113
      Height = 53
      Caption = 'Novo Pedido'
      TabOrder = 0
      OnClick = ButtonNovoPedidoClick
    end
    object ButtonSelecionaPedido: TButton
      Left = 114
      Top = 1
      Width = 113
      Height = 53
      Caption = 'Selecionar Pedido'
      TabOrder = 1
      OnClick = ButtonSelecionaPedidoClick
    end
    object ButtonSalvaPedido: TButton
      Left = 227
      Top = 1
      Width = 113
      Height = 53
      Caption = 'Salvar Pedido'
      TabOrder = 2
      OnClick = ButtonSalvaPedidoClick
    end
    object ButtonCancelar: TButton
      Left = 340
      Top = 1
      Width = 113
      Height = 53
      Caption = 'Cancelar Pedido'
      TabOrder = 3
      OnClick = ButtonCancelarClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 61
    Width = 899
    Height = 57
    Align = alTop
    TabOrder = 1
    object LabelDTEmissao: TLabel
      Left = 6
      Top = 3
      Width = 62
      Height = 13
      Caption = 'Data Pedido:'
    end
    object Label5: TLabel
      Left = 125
      Top = 5
      Width = 96
      Height = 13
      Caption = 'Quantidade de Itens'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 241
      Top = 5
      Width = 60
      Height = 13
      Caption = 'Valor Pedido'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 351
      Top = 5
      Width = 32
      Height = 13
      Caption = 'Cliente'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SpeedButtonCliente: TSpeedButton
      Left = 631
      Top = 21
      Width = 23
      Height = 22
      Hint = 'Localizar cliente'
      Caption = '....'
      OnClick = SpeedButtonClienteClick
    end
    object LabelNumPedido: TLabel
      Left = 672
      Top = 26
      Width = 78
      Height = 13
      Caption = 'LabelNumPedido'
    end
    object DateEditEmissao: TDateEdit
      Left = 6
      Top = 22
      Width = 107
      Height = 21
      Hint = 'Data de Emiss'#227'o da Nota'
      CheckOnExit = True
      Enabled = False
      NumGlyphs = 2
      YearDigits = dyFour
      TabOrder = 0
      Text = '01/01/2000'
    end
    object EditQtdItens: TEdit
      Left = 125
      Top = 22
      Width = 100
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 14
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '12345678901234'
    end
    object EditCliente: TEdit
      Left = 351
      Top = 22
      Width = 274
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 14
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '12345678901234'
    end
    object EditValorPedido: TCurrencyEdit
      Tag = 2
      Left = 238
      Top = 22
      Width = 97
      Height = 21
      Hint = 'Valor Produto'
      Margins.Left = 1
      Margins.Top = 1
      AutoSize = False
      DisplayFormat = '##,#0.00'
      TabOrder = 3
    end
  end
  object DBGridItens: TDBGrid
    Left = 0
    Top = 118
    Width = 899
    Height = 346
    Hint = 'Itens da Nota Fiscal'
    Align = alTop
    DataSource = DSItens
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'NROITEM'
        Title.Caption = 'N'#186' Item'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRODUTO'
        Title.Caption = 'Produto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o Produto'
        Width = 330
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QTD'
        Title.Alignment = taRightJustify
        Title.Caption = 'Quantidade'
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VLRUNIT'
        Title.Alignment = taRightJustify
        Title.Caption = 'Valor Unit'#225'rio'
        Width = 155
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VLRTOTAL'
        Title.Alignment = taRightJustify
        Title.Caption = 'Valor Total'
        Width = 155
        Visible = True
      end>
  end
  object BtIncluirProduto: TButton
    Left = 423
    Top = 466
    Width = 84
    Height = 38
    Hint = 'Inclui item para nota fiscal selecionada'
    Caption = 'Incluir'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = BtIncluirProdutoClick
  end
  object BtAlterarProduto: TButton
    Left = 506
    Top = 466
    Width = 84
    Height = 38
    Hint = 'Altera iten referente a nota selecionada'
    Caption = 'Alterar'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = BtAlterarProdutoClick
  end
  object BtExcluirProduto: TButton
    Left = 589
    Top = 466
    Width = 84
    Height = 38
    Hint = 'Excluir item referente a nota selecionada'
    Caption = '&Excluir'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = BtExcluirProdutoClick
  end
  object BarraNavega: TDBNavigator
    Left = 226
    Top = 466
    Width = 192
    Height = 39
    DataSource = DSItens
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    Hints.Strings = (
      'Primeiro registro'
      'Registro anterior'
      'Proximo registro'
      'Ultimo registro'
      'Insert record'
      'Delete record'
      'Edit record'
      'Post edit'
      'Cancel edit'
      'Refresh data')
    TabOrder = 6
  end
  object VTItens: TVirtualTable
    FieldDefs = <
      item
        Name = 'PRODUTO'
        DataType = ftInteger
      end
      item
        Name = 'DESCRICAO'
        DataType = ftString
        Size = 240
      end
      item
        Name = 'QTD'
        DataType = ftFloat
        Precision = 15
      end
      item
        Name = 'VLRUNIT'
        DataType = ftFloat
        Precision = 15
      end
      item
        Name = 'VLRTOTAL'
        DataType = ftFloat
        Precision = 15
      end>
    Left = 300
    Top = 180
    Data = {
      04000500070050524F4455544F0300000000000000090044455343524943414F
      0100F000000000000300515444060000000F0000000700564C52554E49540600
      00000F0000000800564C52544F54414C060000000F000000000000000000}
    object VTItensNROITEM: TStringField
      FieldName = 'NROITEM'
      Size = 3
    end
    object VTItensPRODUTO: TIntegerField
      FieldName = 'PRODUTO'
    end
    object VTItensDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 240
    end
    object VTItensQTD: TFloatField
      FieldName = 'QTD'
      DisplayFormat = '###,###,###.##'
    end
    object VTItensVLRUNIT: TFloatField
      FieldName = 'VLRUNIT'
      DisplayFormat = '###,###,###.##'
    end
    object VTItensVLRTOTAL: TFloatField
      FieldName = 'VLRTOTAL'
      DisplayFormat = '###,###,###.##'
    end
  end
  object DSItens: TDataSource
    DataSet = VTItens
    Left = 244
    Top = 204
  end
end
