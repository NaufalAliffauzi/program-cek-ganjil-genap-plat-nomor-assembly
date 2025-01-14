ORG 100h ; Program dimulai pada offset 100h

; Menampilkan pesan untuk memasukkan plat nomor
MOV DX, OFFSET msg1
MOV AH, 9
INT 21h

; Membaca plat nomor dari keyboard (maks 4 digit)
LEA SI, plate_input ; SI menunjuk ke buffer plate_input
MOV CX, 4          ; Maksimal 4 digit
NEXT_DIGIT:
    MOV AH, 1       ; Membaca karakter dari keyboard
    INT 21h
    CMP AL, 0Dh     ; Cek apakah tombol Enter ditekan
    JE PROCESS      ; Jika Enter, selesai membaca
    SUB AL, '0'     ; Konversi dari ASCII ke angka
    JC INVALID      ; Jika bukan angka, loncat ke INVALID
    MOV [SI], AL    ; Simpan angka di buffer
    INC SI          ; Geser pointer ke buffer berikutnya
    LOOP NEXT_DIGIT ; Ulangi hingga 4 digit atau Enter ditekan

PROCESS:
    ; Ambil digit terakhir dari buffer
    DEC SI          ; SI menunjuk ke digit terakhir
    MOV AL, [SI]    ; Ambil digit terakhir

    ; Mengecek apakah digit terakhir genap atau ganjil
    MOV BL, AL      ; Simpan digit terakhir di BL
    MOV AH, 0       ; Bersihkan AH
    MOV CL, 2       ; CL = 2
    DIV CL          ; Membagi BL dengan 2
    CMP AH, 0       ; Cek sisa hasil pembagian
    JZ EVEN         ; Jika AH = 0, maka genap

ODD: ; Tampilkan pesan Ganjil
    MOV DX, OFFSET msg_odd
    MOV AH, 9
    INT 21h
    JMP END

EVEN: ; Tampilkan pesan Genap
    MOV DX, OFFSET msg_even
    MOV AH, 9
    INT 21h
    JMP END

INVALID: ; Pesan jika input tidak valid
    MOV DX, OFFSET msg_invalid
    MOV AH, 9
    INT 21h
    JMP END

END: ; Mengakhiri program
    MOV AH, 4Ch
    INT 21h

; Data section
msg1 DB 'Masukkan 4 digit plat nomor kendaraan(hanya angka): $'
msg_even DB 0Dh, 0Ah, 'Plat nomor anda GENAP.$'
msg_odd DB 0Dh, 0Ah, 'Plat nomor anda GANJIL.$'
msg_invalid DB 0Dh, 0Ah, 'Input tidak valid! Hanya masukkan angka.$'
plate_input DB 4 DUP(?) ; Buffer untuk menyimpan plat nomor

END
